//
//  GameCoordinator.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

//This class is created after matching process. It coordinates UI and available action for current player, opens win/lose screen etc.
//it subscribes for server acrtion, and emit actions from player to server
import Foundation

protocol GameCoordinatorBridgeProtocol: class, GameCoordinatorInputProtocol, GameCoordinatorOutputProtocol {
}
protocol GameCoordinatorInputProtocol {
    //Interface to receive actions from server
    var serverStateMessages: PublishRelay<ServerMessage> { get }
}
protocol GameCoordinatorOutputProtocol {
    //Interface to send actions to server (player actions)
    var playerStateMessage: PublishSubject<PlayerMessage> { get }
}



class GameCoordinator: GameCoordinatorBridgeProtocol {
    
    private let disposeBag = DisposeBag()

    @Published var arManager: ARViewManager = ARViewManager()
    
    private var player: Player?
    internal var map: [[WrappedMapCell]] = []
    private var stashedItems: [Player: [Ball]] = [:]
    private var myStashedItems: [Ball] {
        guard let player = self.player else { return [] }
        return stashedItems[player] ?? []
    }
    
    public var currentServerPayload: ServerMessagePayloadProtocol?
    //MARK: - Input
    var serverStateMessages: PublishRelay<ServerMessage> = PublishRelay<ServerMessage>()
    
    //MARK: - Output
    
    var playerStateMessage: PublishSubject<PlayerMessage> = PublishSubject<PlayerMessage>()
    
    init() {
        serverStateMessages.subscribe { (event) in
            switch event {
            case .next(let message):
                self.handle(message: message)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
        arManager.playerPickedItem.subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let coordinate):
                guard let payload = self.currentServerPayload as? PlayerTurnServerPayload else { return }
                if let coordinate = coordinate {
                    self.arManager.updateAvailablePoints(coordinates: payload.availableToMove?[coordinate] ?? [])
                }
                else {
                    self.arManager.updateAvailablePoints(coordinates: payload.availablePointsFromStash ?? [])
                }
            case .error(_), .completed:
                break
            }
        }.disposed(by: disposeBag)
        arManager.playerPlacedItem.subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let item):
                self.playerStateMessage.onNext(PlayerMessage(type: .playerFinishedTurn, payload: PlayerFinishedTurnMessagePayload(player: self.player!, fromCoordinate: item.0, toCoordinate: item.1, item: self.myStashedItems[0])))
            case .error(_), .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func handle(message: ServerMessage) {
        switch message.type {
        case .initiated:
            guard let payload = message.payload as? InitiatedServerMessagePayload else { return }
            handleInitiatedState(payload: payload)
        case .gameConfig:
            guard let payload = message.payload as? GameConfigServerPayload else { return }
            self.handleUpdateGameConfig(payload: payload)
        case .playerTurn:
            guard let payload = message.payload as? PlayerTurnServerPayload else { return }
            self.handlePlayerTurn(payload: payload)
        default:
            break
        }
    }
}

extension GameCoordinator {
    func handleInitiatedState(payload: InitiatedServerMessagePayload) {
        self.player = payload.player
        self.player?.playerName = "Vitalii"
        self.arManager.arViewInitialized.distinctUntilChanged().filter({ $0 }).subscribe { (event) in
            self.playerStateMessage.onNext(PlayerMessage(type: .initiated, payload: InitiatedPlayerMessagePayload(player: self.player!)))
        }.disposed(by: disposeBag)
    }
}

extension GameCoordinator {
    func handleUpdateGameConfig(payload: GameConfigServerPayload) {
        self.map = payload.map
        self.stashedItems = payload.stashedItems
        self.arManager.updateGameConfig(player: self.player!, map: self.map, stashedItems: self.stashedItems)
    }
}

extension GameCoordinator {
    func handlePlayerTurn(payload: PlayerTurnServerPayload) {
        if payload.isPlayerTurn {
            self.currentServerPayload = payload
            let availableToMove: [Coordinate] = Array((payload.availableToMove ?? [:]).keys)
            self.arManager.updatePlayerTurn(availableToMove:availableToMove)
        }
        else {
            self.arManager.updateWaitingState()
        }
    }
}

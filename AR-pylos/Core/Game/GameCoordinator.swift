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
        _ = self.arManager.arViewInitialized.take(1).map({ _ in self.playerStateMessage.onNext(PlayerMessage(type: .initiated, payload: InitiatedPlayerMessagePayload(player: self.player!))) })
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
        guard let player = self.player else { return }
        if payload.isPlayerTurn {
            self.currentServerPayload = payload
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playerStateMessage.onNext(PlayerMessage(type: .playerFinishedTurn, payload: PlayerFinishedTurnMessagePayload(player: player, fromCoordinate: nil, toCoordinate: payload.availablePointsFromStash![0], item: self.myStashedItems[0])))
            }
            //We are current player, unlock controls, update ui, wait for action from player
        }
        else {
            //Update ui with waiting screen
        }
    }
}

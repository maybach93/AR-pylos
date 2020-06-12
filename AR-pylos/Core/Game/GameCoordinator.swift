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

    private var playerId: String = ""
    private var map: [[WrappedMapCell]] = []
    private var stashedItems: [Player: [Ball]] = [:]
    
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
        default:
            break
        }
    }
}

extension GameCoordinator {
    func handleInitiatedState(payload: InitiatedServerMessagePayload) {
        self.playerId = payload.playerId
        self.playerStateMessage.onNext(PlayerMessage(type: .initiated, payload: InitiatedPlayerMessagePayload(playerId: self.playerId, playerName: "vitalii")))
    }
}

extension GameCoordinator {
    func handleUpdateGameConfig(payload: GameConfigServerPayload) {
        self.map = payload.map
        self.stashedItems = payload.stashedItems
        //Draw UI
    }
}

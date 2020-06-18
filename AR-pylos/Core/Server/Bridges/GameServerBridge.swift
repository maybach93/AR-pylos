//
//  RemoteGameServerBridge.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
//Player is remote
//RemotePlayerServerBridge emits actions for player received from communicator and send
//to communicator actions from server
class RemotePlayerServerBridge: GameCoordinatorBridgeProtocol {
    
    //MARK: - Outputs
    var playerStateMessage: PublishSubject<PlayerMessage> = PublishSubject<PlayerMessage>()
    
    //MARK: - Inputs
    var serverStateMessages: PublishRelay<ServerMessage> = PublishRelay<ServerMessage>()
    
    //MARK: - Private
    
    private let disposeBag = DisposeBag()

    private var communicator: CommunicatorAdapter
    
    init(communicator: CommunicatorAdapter) {
        self.communicator = communicator
      
        serverStateMessages.subscribe { (event) in
            switch event {
                
            case .next(let message):
                guard let data = try? JSONEncoder().encode(message) else { return }
                self.communicator.outMessages.accept(data)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
        
        self.communicator.inMessages.subscribe { (event) in
            switch event {
            case .next(let data):
                guard let message = try? JSONDecoder().decode(PlayerMessage.self, from: data) else { return }
                self.playerStateMessage.onNext(message)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
}

//Server is remote
//Reveives actions from server via communicator and emit them to coordinator
//subscribes to actions from coordinator and sends them to RemotePlayerServerBridge(via communicator)
class RemoteServerBridge: GameServerProtocol {
    
    private let disposeBag = DisposeBag()

    private var communicator: CommunicatorAdapter
    private var coordinator: GameCoordinatorBridgeProtocol
    
    init(communicator: CommunicatorAdapter, coordinator: GameCoordinatorBridgeProtocol) {
        self.communicator = communicator
        self.coordinator = coordinator
        
        self.coordinator.playerStateMessage.subscribe { (event) in
            switch event {
            case .next(let message):
                guard let data = try? JSONEncoder().encode(message) else { return }
                self.communicator.outMessages.accept(data)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
        
        self.communicator.inMessages.subscribe { (event) in
            switch event {
            case .next(let data):
                guard let message = try? JSONDecoder().decode(ServerMessage.self, from: data) else { return }
                self.coordinator.serverStateMessages.accept(message)
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
}

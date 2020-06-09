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
    var playerAction: PublishSubject<Void> = PublishSubject<Void>()
    
    //MARK: - Inputs
    var serverStateMessages: PublishRelay<ServerMessage> = PublishRelay<ServerMessage>()
    
    //MARK: - Private
    
    private var communicator: CommunicatorAdapter
    
    init(communicator: CommunicatorAdapter) {
        self.communicator = communicator
    }
}

//Server is remote
//Reveives actions from server via communicator and emit them to coordinator
//subscribes to actions from coordinator and sends them to RemotePlayerServerBridge(via communicator)
class RemoteServerBridge: GameServerProtocol {
    init(coordinator: GameCoordinatorBridgeProtocol) {
        //With communicator and coordinator
    }
}

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
    init() {
        //With communicator
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

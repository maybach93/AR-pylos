//
//  GameServer.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/5/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

//This protocol is the interface between server and players.
//It receives actions/signals from server to update information or UI
//It sends user actions to server locally or via Network

protocol GameServerProtocol {
    
}

class GameServer: GameServerProtocol {
    private var gameCoordinators: [GameCoordinatorBridgeProtocol]
    
    init(gameCoordinators: [GameCoordinatorBridgeProtocol]) {
        self.gameCoordinators = gameCoordinators
    }
}

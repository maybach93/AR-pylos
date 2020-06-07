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

protocol GameServerContext: class {
    var gameCoordinators: [GameCoordinatorBridgeProtocol] { get }
}

class GameServer: GameServerProtocol, GameServerContext {
    internal var gameCoordinators: [GameCoordinatorBridgeProtocol]
    lazy private var gameState: BaseGameState = {
        return BaseGameState(context: self)
    }()
    
    init(gameCoordinators: [GameCoordinatorBridgeProtocol]) {
        self.gameCoordinators = gameCoordinators
        self.executeNextState()
    }
    
    func executeNextState() {
        self.gameState = self.gameState.nextState()
    }
}

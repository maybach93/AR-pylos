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
    var gameCoordinators: [Player: GameCoordinatorBridgeProtocol] { get }
    var players: [Player] { get }
    var currentPlayer: Player? { get set }
    var game: Game { get }
}

class GameServer: GameServerProtocol, GameServerContext {
    internal var game: Game
    internal var gameCoordinators: [Player: GameCoordinatorBridgeProtocol]
    internal var players: [Player] {
        return Array(gameCoordinators.keys)
    }
    internal weak var currentPlayer: Player?
    
    lazy private var gameState: BaseGameState = {
        return BaseGameState(context: self)
    }()
    
    init(gameCoordinators: [GameCoordinatorBridgeProtocol]) {
        let game = Game()
        var gameCoordinatorsDict: [Player: GameCoordinatorBridgeProtocol] = [:]
        for (index, gameCoordinator) in gameCoordinators.enumerated() {
            let player = game.players[index]
            gameCoordinatorsDict[player] = gameCoordinator
        }
        self.gameCoordinators = gameCoordinatorsDict
        self.game = game
        self.executeNextState()
    }
    
    func executeNextState() {
        self.gameState = self.gameState.nextState()
    }
}

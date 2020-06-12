//
//  GameStateMachine.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

public enum GameStateMachine: Int {
    case none = 0
    case initiated //Server sends initiated event and waits for every player to be ready
    case started //When all players confirmed "ready" status, the game starts. Server chooses first player and sends config events (how to set up UI)
    case playerTurn //Server sends events to currentPlayer to Action, and other player to wait for currentPlayer //Server waits for currentPlayer to send Action. Once server got event, it goes to next state
    case playerFinishedTurn //Server update its state and checks for winner, sends update config events to update UI, then in a meanwhile if there is a winner server goes to playerWon state, otherwice to NEXT playerTurn
    case playerWon //Once there is a winner, server sends events to all players to update UI
    case finished // finally server notifies every player and terminates
    
    init() {
        self = .none
    }
}

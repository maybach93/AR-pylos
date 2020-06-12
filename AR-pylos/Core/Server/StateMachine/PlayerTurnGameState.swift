//
//  PlayerTurnGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class PlayerTurnGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .playerTurn
    }
    
    func movingFrom(previousState: BaseGameState) {
        guard let oldCurrentPlayer = self.context.currentPlayer else { return }
        self.context.currentPlayer = self.context.gameCoordinators.keys.map({ $0 as Player }).compactMap({ $0 }).next(current: oldCurrentPlayer )
        
        
        self.context.gameCoordinators.keys.forEach { (player) in
            let isPlayerTurn = self.context.currentPlayer == player
            
            let availablePoints = self.context.game.map.availablePoints
            let availableToMove = self.context.game.availableToMove(to: player)
            var availableToMoveToPlayer: [Coordinate: [Coordinate]] = [:]
            
            availableToMove.forEach { (coordinate) in
                guard let childs = self.context.game.map[coordinate]?.cellChilds else { return }
                availableToMoveToPlayer[coordinate] = availablePoints.filter({ (coordinateToFilter) -> Bool in
                    guard let mapCell = self.context.game.map[coordinateToFilter] else { return false }
                    return !childs.contains(where: { mapCell === $0 })
                })
            }
            
            self.context.gameCoordinators[player]?.serverStateMessages.accept(ServerMessage(type: .playerTurn, payload: PlayerTurnServerPayload(playerId: player.id, isPlayerTurn: isPlayerTurn, availableToMove: availableToMoveToPlayer, availablePointsFromStash: availablePoints)))
        }
        
    }
    
    override func nextState() -> BaseGameState {
        let state = StartedGameState(context: context)
        state.movingFrom(previousState: self)
        return state
    }
}

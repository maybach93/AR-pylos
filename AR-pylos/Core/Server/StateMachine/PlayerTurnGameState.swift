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
    
    deinit {
        print("")
    }
    
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create {} }
            
            guard let oldCurrentPlayer = self.context.currentPlayer else { return Disposables.create {} }
            self.context.currentPlayer = self.context.players.next(current: oldCurrentPlayer )
            guard let currentPlayer = self.context.currentPlayer else { return Disposables.create {} }
            
            self.context.players.forEach { (player) in
                let isPlayerTurn = currentPlayer == player
                
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
                
                self.context.gameCoordinators[player]?.serverStateMessages.accept(ServerMessage(type: .playerTurn, payload: PlayerTurnServerPayload(player: player, isPlayerTurn: isPlayerTurn, availableToMove: availableToMoveToPlayer, availablePointsFromStash: availablePoints)))
            }
            observer.onNext(true)
            
            return Disposables.create {}
        })
    }
    
    override func nextState() -> BaseGameState {
        let state = PlayerFinishedTurnGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

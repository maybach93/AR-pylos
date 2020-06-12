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
        self.context.gameCoordinators.keys.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .gameConfig, payload: GameConfigServerPayload(playerId: $0.id, map: self.context.game.map.map, stashedItems: self.context.game.stashedItems))) })
        
    }
    
    override func nextState() -> BaseGameState {
        let state = StartedGameState(context: context)
        state.movingFrom(previousState: self)
        return state
    }
}

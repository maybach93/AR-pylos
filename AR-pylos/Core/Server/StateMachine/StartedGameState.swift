//
//  StartedGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class StartedGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .started
    }
    
    func movingFrom(previousState: BaseGameState) {
        self.context.currentPlayer = self.context.gameCoordinators.keys.first
        self.context.gameCoordinators.keys.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .gameConfig, payload: GameConfigServerPayload(playerId: $0.id, map: self.context.game.map.map, stashedItems: self.context.game.stashedItems))) })
        self.nextState()
        
    }
    
    override func nextState() -> BaseGameState {
        let state = PlayerTurnGameState(context: context)
        state.movingFrom(previousState: self)
        return state
    }
}

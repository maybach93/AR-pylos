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
    
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create {} }
            self.context.gameCoordinators.keys.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .gameConfig, payload: GameConfigServerPayload(player: $0, map: self.context.game.map.map, stashedItems: self.context.game.stashedItems))) })
            observer.onNext(true)
            return Disposables.create {}
        })
    }
    
    override func nextState() -> BaseGameState {
        let state = PlayerTurnGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

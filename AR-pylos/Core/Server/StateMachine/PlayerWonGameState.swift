//
//  PlayerWonGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class PlayerWonGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .playerWon
    }
    
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self, let currentPlayer = self.context.currentPlayer else { return Disposables.create {} }
 
            self.context.players.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .playerWon, payload: PlayerWonServerPayload(player: $0, winner: currentPlayer)))})
            observer.onNext(true)
            return Disposables.create {}
        }).delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    }
    
    override func nextState() -> BaseGameState {
        let state = FinishedGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

//
//  PlayerFinishedTurnGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class PlayerFinishedTurnGameState: BaseGameState {
    
    private var isCurrentPlayerWon: Bool = false
    
    override var state: GameStateMachine {
        return .playerFinishedTurn
    }
    
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self, let currentPlayer = self.context.currentPlayer else { return Disposables.create {} }

            self.context.gameCoordinators[currentPlayer]?.playerStateMessage.subscribe(onNext: { [weak self] (message) in
                guard let self = self, let payload = message.payload as? PlayerFinishedTurnMessagePayload else { return }
                if let fromCoordinate = payload.fromCoordinate {
                    _ = self.context.game.moveItem(player: currentPlayer, fromCoordinate: fromCoordinate, toCoordinate: payload.toCoordinate)
                }
                else {
                    guard let stashedItem = self.context.game.stashedItems[payload.player]?.first else { return }
                    _ = self.context.game.fillItem(player: currentPlayer, item: stashedItem, coordinate: payload.toCoordinate)
                }

                if self.context.game.map.availablePoints.isEmpty {
                    self.isCurrentPlayerWon = true
                }
                
                self.context.players.filter({ $0 != currentPlayer }).forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .playerFinishedTurn, payload: PlayerFinishedTurnServerPayload(player: $0, currentPlayer: currentPlayer, fromCoordinate: payload.fromCoordinate, toCoordinate: payload.toCoordinate, item: payload.item))) })
                observer.onNext(true)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            return Disposables.create {}
        })
    }
    
    override func nextState() -> BaseGameState {
        let state = self.isCurrentPlayerWon ? PlayerWonGameState(context: context) : StartedGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

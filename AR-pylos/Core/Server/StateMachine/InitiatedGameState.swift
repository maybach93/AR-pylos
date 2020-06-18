//
//  InitiatedGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class InitiatedGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .initiated
    }
  
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create {} }
            Observable.zip(self.context.gameCoordinators.values.map({ $0.playerStateMessage.asObservable() })).subscribe({ [weak self] (event) in
                switch event {
                case .next(let response):
                    for player in response {
                        self?.context.gameCoordinators.keys.first(where: { $0 == player.payload.player })?.playerName = (player.payload as? InitiatedPlayerMessagePayload)?.player.playerName
                    }
                    self?.context.currentPlayer = self?.context.gameCoordinators.keys.first
                    observer.onNext(true)
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
            Observable.just(Void.self).delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
                self.context.gameCoordinators.keys.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .initiated, payload: InitiatedServerMessagePayload(player: $0))) })
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            return Disposables.create {}
        })
    }
    
    override func nextState() -> BaseGameState {
        let state = StartedGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

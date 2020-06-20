//
//  FinishedGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class FinishedGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .finished
    }
    
    override func movingFromPreviousState() {
        self.readyForNextStart = Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create {} }
            Observable.zip(self.context.gameCoordinators.values.map({ $0.playerStateMessage.asObservable() })).subscribe(onNext: { [weak self] (_) in
                self?.context.stopServer()
            }).disposed(by: self.disposeBag)
            return Disposables.create {}
        })
    }
}

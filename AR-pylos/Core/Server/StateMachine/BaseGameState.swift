//
//  BaseGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class BaseGameState {
    
    let disposeBag = DisposeBag()
    
    unowned var context: GameServerContext
    
    var readyForNextStart: Observable<Bool>?
    var state: GameStateMachine {
        return .none
    }

    //MARK: - Init
    
    init(context: GameServerContext) {
        self.context = context
    }
    
    //MARK: - Public
    
    func movingFromPreviousState() {
        
    }
    
    func nextState() -> BaseGameState {
        let state = InitiatedGameState(context: context)
        state.movingFromPreviousState()
        return state
    }
}

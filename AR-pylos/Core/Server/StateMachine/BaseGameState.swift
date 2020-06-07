//
//  BaseGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class BaseGameState {
    private unowned var context: GameServerContext
    var state: GameStateMachine {
        return .none
    }
    
    //MARK: - Init
    
    init(context: GameServerContext) {
        self.context = context
    }
    
    //MARK: - Public
    
    func nextState() -> BaseGameState {
        return InitiatedGameState(context: context)
    }
}

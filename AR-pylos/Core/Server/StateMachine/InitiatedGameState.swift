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
    
    func movingFrom(previousState: BaseGameState) {

    }
}

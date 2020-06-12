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
        self.context.stopServer()
    }
}

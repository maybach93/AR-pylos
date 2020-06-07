//
//  MapItem.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/4/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

protocol MapItemProtocol: class {
    var owner: Player { get }
}

class Ball: MapItemProtocol {
    unowned let owner: Player
    
    init(owner: Player) {
        self.owner = owner
    }
    
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        return lhs === rhs
    }
}

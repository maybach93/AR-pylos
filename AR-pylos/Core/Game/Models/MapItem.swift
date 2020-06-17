//
//  MapItem.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/4/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

protocol MapItemProtocol: class {
    var id: String { get }
    var owner: Player { get }
}

class Ball: MapItemProtocol, Codable {
    var id: String = UUID().uuidString
    let owner: Player
    
    init(owner: Player) {
        self.owner = owner
    }
    
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        return lhs.id == rhs.id
    }
}

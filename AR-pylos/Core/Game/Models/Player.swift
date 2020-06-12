//
//  Player.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/5/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class Player: Equatable, Hashable, Codable {
    var id: String
    var playerName: String?
    
    convenience init() {
        self.init(id: UUID().uuidString)
    }
    
    init(id: String) {
        self.id = id
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

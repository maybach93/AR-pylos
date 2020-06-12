//
//  GameConfigServerPayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class WrappedMapCell: Codable {
    var item: Ball?
    var child: WrappedMapCell?
    
    init(cell: MapCellProtocol) {
        self.item = cell.item as? Ball
        if let child = cell.child {
            self.child = WrappedMapCell(cell: child)
        }
    }
    
    subscript(z: Int) -> WrappedMapCell? {
        if z == 0 {
            return self
        }
        return child?[z - 1]
    }
}

struct GameConfigServerPayload: ServerMessagePayloadProtocol {
    var player: Player
    
    var map: [[WrappedMapCell]]
    var stashedItems: [Player: [Ball]]
    
    init(player: Player, map: [[MapCellProtocol]], stashedItems: [Player: [MapItemProtocol]]) {
        self.player = player
        self.map = map.map({ $0.map({ WrappedMapCell(cell: $0) })})
        self.stashedItems = stashedItems as? [Player: [Ball]] ?? [:]
    }
}

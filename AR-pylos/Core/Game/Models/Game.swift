//
//  Game.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/5/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
protocol GameProtocol {
    func moveItem(player: Player, fromCoordinate: Coordinate, toCoordinate: Coordinate) -> Bool
    func fillItem(player: Player, item: MapItemProtocol, coordinate: Coordinate) -> Bool
    func stashItem(player: Player, coordinate: Coordinate) -> Bool
    func availableToMove(to player: Player) -> [Coordinate]
}

class Game {
    var map: GameMapProtocol
    private(set) var stashedItems: [Player: [MapItemProtocol]]
    private(set) var players: [Player]

    init(width: Int = 4, playersAmount: Int = 2) {
        var players: [Player] = []
        for _ in 0...(playersAmount - 1) {
            players.append(Player())
        }
        self.players = players
        
        self.map = GameMap(width: width)
        
        let numberOfItems = Int(self.map.allPoints.count / playersAmount)
        var items: [Player: [MapItemProtocol]] = [:]
        for player in self.players {
            items[player] = []
            for _ in (1...numberOfItems) {
                items[player]?.append(Ball(owner: player))
            }
        }
        self.stashedItems = items
    }
    
    func moveItem(player: Player, fromCoordinate: Coordinate, toCoordinate: Coordinate) -> Bool {
        guard let fromCellItem = self.map[fromCoordinate]?.item, let toCell = self.map[toCoordinate] else { return false }
        guard self.availableToMove(to: player).contains(where: { $0 == fromCoordinate }), toCell.isAvailableToFill else { return false }
        
        return self.map.fill(coordinate: fromCoordinate, item: nil) && self.map.fill(coordinate: toCoordinate, item: fromCellItem)
    }
    
    func fillItem(player: Player, item: MapItemProtocol, coordinate: Coordinate) -> Bool {
        guard let indexOfItem = self.stashedItems[player]?.lastIndex(where: { $0 === item }) else { return false }
        self.stashedItems[player]?.remove(at: indexOfItem)
        return self.map.fill(coordinate: coordinate, item: item)
    }
    
    func stashItem(player: Player, coordinate: Coordinate) -> Bool {
        guard let item = self.map[coordinate]?.item else { return false }
        _ = self.map.fill(coordinate: coordinate, item: nil)
        self.stashedItems[player]?.append(item)
        return true
    }
    
    func availableToMove(to player: Player) -> [Coordinate] {
        return self.map.availableToMovePoints.filter({ self.map[$0]?.item?.owner == player })
    }
}

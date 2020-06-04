//
//  GameMap.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 5/31/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//
import Foundation

struct Coordinate {
    var x: Int
    var y: Int
    var z: Int
}

protocol GameMapProtocol {
    var availablePoints: [Coordinate] { get }
    var occupiedPoints: [Coordinate] { get }
}

struct GameMap: GameMapProtocol {
    
    private var map: [[MapCellProtocol]]
    
    var availablePoints: [Coordinate] {
        var availablePoints: [Coordinate] = []
        
        for x in 0...(self.map.count - 1) {
            for y in 0...(self.map.count - 1) {
                for z in 0...(self.map.count - 2) {
                    if self.map[x][y][z]?.isAvailable == true {
                        availablePoints.append(Coordinate(x: x, y: y, z: z))
                    }
                }
            }
        }
        return availablePoints
    }
    
    var occupiedPoints: [Coordinate] {
        var occupiedPoints: [Coordinate] = []
        
        for x in 0...(self.map.count - 1) {
            for y in 0...(self.map.count - 1) {
                for z in 0...(self.map.count - 2) {
                    if self.map[x][y][z]?.isAvailable == false {
                        occupiedPoints.append(Coordinate(x: x, y: y, z: z))
                    }
                }
            }
        }
        return occupiedPoints
    }
    
    init(width: Int) {
        var map: [[MapCellProtocol]] = []
        for z in 0...(width - 1) {
            for x in 0...(width - 1 - z) {
                var row: [MapCellProtocol] = []
                for y in 0...(width - 1 - z) {
                    if z == 0 {
                        row.append(RootMapCell())
                    }
                    else {
                        let cell = MapCell()
                        cell.parentUpLeft = map[x][y][z - 1]
                        cell.parentUpRight = map[x][y + 1][z - 1]
                        cell.parentDownLeft = map[x + 1][y][z - 1]
                        cell.parentDownRight = map[x + 1][y + 1][z - 1]
                        cell.parentUpLeft?.childDownRight = cell
                        cell.parentUpRight?.childDownLeft = cell
                        cell.parentDownLeft?.childUpRight = cell
                        cell.parentDownRight?.childUpLeft = cell
                    }
                }
                if z == 0 {
                    map.append(row)
                }
            }
        }
        self.map = map
    }
}

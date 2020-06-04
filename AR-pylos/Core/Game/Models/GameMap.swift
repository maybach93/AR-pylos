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
    var filledPoints: [Coordinate] { get }
    subscript(coordinate: Coordinate) -> MapCellProtocol? { get }
    
    func fill(coordinate: Coordinate) -> Bool
    func fill(coordinate: Coordinate, item: MapItemProtocol?) -> Bool
}

struct GameMap: GameMapProtocol {
    
    private var map: [[MapCellProtocol]]
    
    var availablePoints: [Coordinate] {
        var availablePoints: [Coordinate] = []
        
        for z in 0...(self.map.count - 1) {
            for x in 0...(self.map.count - 1) {
                for y in 0...(self.map.count - 1) {
                    if self[Coordinate(x: x, y: y, z: z)]?.isAvailable == true {
                        availablePoints.append(Coordinate(x: x, y: y, z: z))
                    }
                }
            }
        }
        return availablePoints
    }
    
    var filledPoints: [Coordinate] {
        var filledPoints: [Coordinate] = []
        
        for z in 0...(self.map.count - 1) {
            for x in 0...(self.map.count - 1) {
                for y in 0...(self.map.count - 1) {
                    
                    if self[Coordinate(x: x, y: y, z: z)]?.isFilled == true {
                        filledPoints.append(Coordinate(x: x, y: y, z: z))
                    }
                }
            }
        }
        return filledPoints
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
    
    subscript(coordinate: Coordinate) -> MapCellProtocol? {
        return self.map[coordinate.x][coordinate.y][coordinate.z]
    }
    
    @discardableResult
    func fill(coordinate: Coordinate, item: MapItemProtocol? = nil) -> Bool {
        guard var cell = self[coordinate] else { return false }
        let temp = cell.item
        cell.item = item
        return (temp == nil) != (item == nil)
    }
}

//
//  MapCell.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/4/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

protocol MapCellProtocol {
    var allParents: [MapCellProtocol] { get }
    var cellParents: [MapCellProtocol] { get }
    
    var childUpLeft: MapCellProtocol? { get set }
    var childUpRight: MapCellProtocol? { get set }
    var childDownLeft: MapCellProtocol? { get set }
    var childDownRight: MapCellProtocol? { get set }
    
    subscript(z: Int) -> MapCellProtocol? { get }
    var isAvailable: Bool { get }
}

class RootMapCell: MapCellProtocol {
    
    var item: Ball?
    
    var childUpLeft: MapCellProtocol?
    var childUpRight: MapCellProtocol?
    var childDownLeft: MapCellProtocol?
    var childDownRight: MapCellProtocol?
    
    var child: MapCellProtocol? {
        return childDownRight
    }
    
    var isAvailable: Bool {
        return item == nil
    }
    var allParents: [MapCellProtocol] {
        return []
    }
    var cellParents: [MapCellProtocol] {
        return []
    }
    
    init() {
        
    }
    
    subscript(z: Int) -> MapCellProtocol? {
        if z == 0 {
            return self
        }
        return child?[z - 1]
    }
}

class MapCell: MapCellProtocol {
    var item: Ball?
    var childUpLeft: MapCellProtocol?
    var childUpRight: MapCellProtocol?
    var childDownLeft: MapCellProtocol?
    var childDownRight: MapCellProtocol?
    
    var parentUpLeft: MapCellProtocol?
    var parentUpRight: MapCellProtocol?
    var parentDownLeft: MapCellProtocol?
    var parentDownRight: MapCellProtocol?
    
    var parent: MapCellProtocol? {
        return parentUpLeft
    }
    
    var child: MapCellProtocol? {
        return childDownRight
    }
    
    var isAvailable: Bool {
        return item == nil && cellParents.count == 4
    }
    
    var allParents: [MapCellProtocol] {
        return [cellParents, parentUpLeft?.allParents, parentUpRight?.allParents, parentDownRight?.allParents, parentDownLeft?.allParents].compactMap({ $0 }).flatMap({ $0 })
    }
    var cellParents: [MapCellProtocol] {
        return [parentUpLeft, parentUpRight, parentDownLeft, parentDownRight].compactMap({ $0 })
    }
    
    subscript(z: Int) -> MapCellProtocol? {
        get {
            if z == 0 {
                return self
            }
            return child?[z - 1]
        }
    }
}
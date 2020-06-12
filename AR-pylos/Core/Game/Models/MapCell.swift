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
    var child: MapCellProtocol? { get }
    
    var isAvailableToFill: Bool { get }
    var isMovable: Bool { get }
    var isFilled: Bool { get }
    var item: MapItemProtocol? { get set }
    
    subscript(z: Int) -> MapCellProtocol? { get }
}

class RootMapCell: MapCellProtocol {

    var item: MapItemProtocol?
    
    var childUpLeft: MapCellProtocol?
    var childUpRight: MapCellProtocol?
    var childDownLeft: MapCellProtocol?
    var childDownRight: MapCellProtocol?
    
    var child: MapCellProtocol? {
        return childDownRight
    }
    
    var isAvailableToFill: Bool {
        return item == nil
    }
    
    var isMovable: Bool {
        return isFilled && childUpLeft == nil && childUpRight == nil && childDownLeft == nil && childDownRight == nil
    }
    
    var isFilled: Bool {
        return item != nil
    }
    
    var allParents: [MapCellProtocol] {
        return []
    }
    var cellParents: [MapCellProtocol] {
        return []
    }
    
    required init() {
        
    }
    
    subscript(z: Int) -> MapCellProtocol? {
        if z == 0 {
            return self
        }
        return child?[z - 1]
    }
}

class MapCell: MapCellProtocol {
    
    var item: MapItemProtocol?
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
    
    var isFilled: Bool {
        return item != nil
    }
    
    var isMovable: Bool {
        return isFilled && childUpLeft == nil && childUpRight == nil && childDownLeft == nil && childDownRight == nil
    }
    
    var isAvailableToFill: Bool {
        return item == nil && cellParents.filter({ $0.isFilled }).count == 4
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

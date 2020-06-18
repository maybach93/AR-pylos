//
//  Colors.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/18/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

enum Colors: Int {
    case white
    case black
    case red
    case orange
    case purple
    
    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .orange:
            return .brown
        case .purple:
            return .purple
        case .black:
            return .black
        case .white:
            return .white
        }
    }
}

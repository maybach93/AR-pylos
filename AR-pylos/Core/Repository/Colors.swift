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
            return UIColor(red: 50.0 / 255.0, green: 24.0 / 255.0, blue: 100.0 / 255.0, alpha: 1)
        case .black:
            return .black
        case .white:
            return .white
        }
    }
}

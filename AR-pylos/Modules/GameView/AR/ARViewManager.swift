//
//  ARViewManager.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/14/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit

class ARViewManager: ObservableObject {
    weak var arView: ARView? {
        didSet {
            print("")
        }
    }
    
}

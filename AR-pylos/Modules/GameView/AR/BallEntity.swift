//
//  BallEntity.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/16/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit

class BallEntity: Entity, HasModel, HasCollision {
    required init(color: UIColor, radius: Float) {
        super.init()

        self.components[CollisionComponent] = CollisionComponent(
            shapes: [.generateSphere(radius: radius)],
            mode: .trigger,
            filter: .sensor
        )
      
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>, radius: Float) {
        self.init(color: color, radius: radius)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

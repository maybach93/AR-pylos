//
//  ARGestureDelegate.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/17/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit

class ARGestureDelegate {
    
    unowned var arViewManager: ARViewManager
    
    init(arViewManager: ARViewManager) {
        self.arViewManager = arViewManager
    }
    
    var isCancel: Bool = false
    var initialPosition: SIMD3<Float>?
    var intersectedItem: Entity?
    var lastIntersectionPosition: SIMD3<Float>?
    @objc func onTap(_ gesture: EntityTranslationGestureRecognizer) {
        switch gesture.state {
            
        case .possible:
            break
        case .began:
            self.isCancel = false
            self.initialPosition = gesture.entity?.position
            break
        case .changed:
            let position = gesture.entity!.position
            let entityY = position.y
            let intersectionY = intersectedItem?.position.y ?? 0
            let vel = gesture.velocity(in: gesture.entity)
            if intersectedItem != nil {
                if entityY - intersectionY - ARViewManager.Constants.ballDiameter + ARViewManager.Constants.yTranslation < 0 {
                    gesture.entity?.position.y += 0.007
                }
                
               // gesture.entity?.position.y += 0.007
            }
            else if entityY > ARViewManager.Constants.initialStashPosition.y + ARViewManager.Constants.yTranslation {
                let intersectionPosition = self.lastIntersectionPosition!
                if abs(position.x - intersectionPosition.x) > ARViewManager.Constants.ballDiameter || abs(position.z - intersectionPosition.z) > ARViewManager.Constants.ballDiameter {
                    gesture.entity?.position.y -= 0.007
                }
            }
            if isCancel {
                gesture.entity?.position = initialPosition!
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
           // gesture.entity.
            break
        case .ended:
break
            
        case .cancelled:
   break
            
        case .failed:
           break
            
        @unknown default:
            break
        }
    }
}

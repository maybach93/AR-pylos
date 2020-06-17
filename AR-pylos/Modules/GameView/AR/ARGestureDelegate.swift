//
//  ARGestureDelegate.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/17/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit

extension ARGestureDelegate {
    struct Constants {
        static let boundsXRange = Range(uncheckedBounds: (lower: Float(-0.532), upper: Float(0.51)))
        static let boundsZRange = Range(uncheckedBounds: (lower: Float(0.308), upper: Float(0.91)))
    }
}
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
            if !Constants.boundsXRange.contains(position.x) {
                gesture.entity?.position.x = position.x < Constants.boundsXRange.lowerBound ? Constants.boundsXRange.lowerBound : Constants.boundsXRange.upperBound
            }
            if !Constants.boundsZRange.contains(position.z) {
                gesture.entity?.position.z = position.z < Constants.boundsZRange.lowerBound ? Constants.boundsZRange.lowerBound : Constants.boundsZRange.upperBound
            }
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

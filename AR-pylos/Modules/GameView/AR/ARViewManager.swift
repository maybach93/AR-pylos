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
    
    var scene: ARGameComposer.ARGameScene!
    var whiteBall: Entity!
    var blackBall: Entity!
    var placement: Entity!
    
    var sceneBlackBalls: [Entity] = []
    var sceneWhiteBalls: [Entity] = []
    var scenePlacements: [Entity] = []
    
    weak var arView: ARView? {
        didSet {
            configureAR()
        }
    }
    
    func configureAR() {
        scene = try! ARGameComposer.loadARGameScene()
        self.whiteBall = scene.whiteBall?.clone(recursive: true)
        self.blackBall = scene.blackBall?.clone(recursive: true)
        self.placement = scene.placement?.clone(recursive: true)
        scene.whiteBall?.removeFromParent()
        scene.blackBall?.removeFromParent()
        scene.placement?.removeFromParent()
        scene.generateCollisionShapes(recursive: true)
        arView?.scene.anchors.append(scene)
        self.updatePlacement(mapWidth: 4)
    }
    
    func updateGameConfig(player: Player, map: [[WrappedMapCell]], stashedItems: [Player: [Ball]]) {
        
        self.updatePlacement(mapWidth: map.count)
        //let blackBall = self.blackBall.clone(recursive: true)
        //scene.addChild(blackBall, preservingWorldTransform: true)
    }
    
    func updatePlacement(mapWidth: Int) {
        for i in 0...(mapWidth - 1) {
            for j in 0...(mapWidth - 1) {
                let placement = self.placement.clone(recursive: true)
                placement.position = [self.placement.position.x + Float(i) * 0.08, self.placement.position.y, self.placement.position.z + Float(j) * 0.08]
                self.scenePlacements.append(placement)
                scene.addChild(placement, preservingWorldTransform: true)
            }
        }
    }
}

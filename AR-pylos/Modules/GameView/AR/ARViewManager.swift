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
    typealias FilledBall = (Coordinate, Entity)
    var scene: ARGameComposer.ARGameScene!
    var whiteBall: Entity!
    var blackBall: Entity!
    var placement: Entity!
    
    var sceneStashedBalls: [Entity] = []
    var sceneFilledBalls: [FilledBall] = []
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
    
    func updateMap(player: Player, map: [[WrappedMapCell]]) {
        
        func add(cell: WrappedMapCell, coordinate: Coordinate) {
            cell.item = Ball(owner: player)
            guard let item = cell.item else { return }
            let zeroPoint: SIMD3<Float> = [self.placement.position.x, self.placement.position.y + 0.04, self.placement.position.z]
            let addedBall = addBall(isWhite: item.owner == player, position: [
                zeroPoint.x + ((Float(coordinate.x) + Float(coordinate.z) / 2.0) * 0.08),
                zeroPoint.y + Float(coordinate.z) * 0.057,
                zeroPoint.z + ((Float(coordinate.y) + Float(coordinate.z) / 2.0) * 0.08)])
            self.sceneFilledBalls.append((coordinate, addedBall))
        }
        
        for (x, itemsX) in map.enumerated() {
            for (y, item) in itemsX.enumerated() {
                var z = 0
                add(cell: item, coordinate: Coordinate(x: x, y: y, z: z))
                var child: WrappedMapCell? = item.child
                while child != nil {
                    guard let currentChild = child else { break }
                    z += 1
                    add(cell: currentChild, coordinate: Coordinate(x: x, y: y, z: z))
                    child = currentChild.child
                }
            }
        }
    }
    
    func addBall(isWhite: Bool, position: SIMD3<Float>) -> Entity {
        let ball = isWhite ? self.whiteBall.clone(recursive: true) : self.blackBall.clone(recursive: true)
        ball.position = position
        scene.addChild(ball, preservingWorldTransform: true)
        return ball
    }
    
    func updateStashedItems(playerItems: [Ball]) {
        let itemsCount = playerItems.count
        for index in 0...(itemsCount - 1) {
            let i = floor(Float(index) / 3.0)
            let j = Int(index - Int(i) * 3)
           
            let addedBall = addBall(isWhite: true, position: [self.whiteBall.position.x + Float(j) * 0.09, self.whiteBall.position.y, self.whiteBall.position.z + Float(i) * 0.09])
            self.sceneStashedBalls.append(addedBall)
        }
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

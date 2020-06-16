//
//  ARViewManager.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/14/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit

class CustomEntityTranslationGestureRecognizer: EntityTranslationGestureRecognizer {
    weak var currentEntity: Entity?
    unowned var arView: ARView
    unowned var manager: ARViewManager
    init(arView: ARView, manager: ARViewManager) {
        self.arView = arView
        self.manager = manager
        super.init(target: nil, action: nil)
    }
    
    @objc override dynamic open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touchLocation = touches.first?.location(in: arView),
            let tappedEntity = arView.hitTest(touchLocation, query: .nearest, mask: .default).first?.entity, tappedEntity.name == "WhiteBall" else {
            return
        }

        currentEntity = tappedEntity
    }

    @objc override dynamic open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touchLocation = touches.first?.location(in: arView),
            let currentEntity = currentEntity else {
            return
        }
        
        print(currentEntity.position)
    }
    
    @objc override dynamic open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.currentEntity = nil
    }
    
    @objc override dynamic open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.currentEntity = nil
    }
}

class ARViewManager: NSObject, ObservableObject {
    
    private let disposeBag = DisposeBag()
    
    var arViewInitialized: PublishSubject<Void> = PublishSubject<Void>()

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
            guard arView != oldValue else { return }
            configureAR()
        }
    }
    
    func configureAR() {
        guard let arView = self.arView else { return }
        scene = try! ARGameComposer.loadARGameScene()
        self.whiteBall = scene.whiteBall?.clone(recursive: true)
        self.blackBall = scene.blackBall?.clone(recursive: true)
        self.placement = scene.placement?.clone(recursive: true)
        scene.whiteBall?.removeFromParent()
        scene.blackBall?.removeFromParent()
        scene.placement?.removeFromParent()
        scene.generateCollisionShapes(recursive: true)
        arView.scene.anchors.append(scene)
        let recognizer = CustomEntityTranslationGestureRecognizer(arView: arView, manager: self)
        arView.addGestureRecognizer(recognizer)
        arView.isUserInteractionEnabled = true

        (scene.wall1?.children.first as? HasModel)?.model?.materials = [SimpleMaterial(color: .clear, isMetallic: true)]
        
//        scene.wall1?.scene?.subscribe(to: CollisionEvents.Began.self, { (event) in
//            print("")
//            })
        arViewInitialized.onNext(())
    }
    
    func updateGameConfig(player: Player, map: [[WrappedMapCell]], stashedItems: [Player: [Ball]]) {
        self.scenePlacements.forEach({ $0.removeFromParent() })
        self.scenePlacements.removeAll()
        self.updatePlacement(mapWidth: map.count)
        
        self.sceneFilledBalls.forEach({ $0.1.removeFromParent() })
        self.sceneFilledBalls.removeAll()
        self.updateMap(player: player, map: map)
        
        self.sceneStashedBalls.forEach({ $0.removeFromParent() })
        self.sceneStashedBalls.removeAll()
        self.updateStashedItems(playerItems: stashedItems[player] ?? [])
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
        arView?.installGestures(.translation, for: ball as! HasCollision)
        ball.generateCollisionShapes(recursive: false)
        scene.addChild(ball, preservingWorldTransform: true)
        ball.name = "WhiteBall"
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

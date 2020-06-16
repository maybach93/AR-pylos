//
//  ARViewManager.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/14/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import RealityKit
import Combine

class CustomEntityTranslationGestureRecognizer: EntityTranslationGestureRecognizer {
    weak var currentEntity: Entity?
    var initialPosition: Transform?
    var isCancelled: Bool = false
    
    unowned var arView: ARView
    unowned var manager: ARViewManager
    init(arView: ARView, manager: ARViewManager) {
        self.arView = arView
        self.manager = manager
        super.init(target: nil, action: nil)
    }
    
    func cancelTouch() {
        self.isCancelled = true
        if let event = event {
            let superview = arView.superview

            self.touches?.forEach({ ignore($0, for: event)})

        }
        
    }
    var event: UIEvent?
    var touches: Set<UITouch>?
    @objc override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touchLocation = touches.first?.location(in: arView),
            let tappedEntity = arView.hitTest(touchLocation, query: .nearest, mask: .default).first?.entity, tappedEntity.name == "WhiteBall" else {
            return
        }
       // self.event = event
        self.touches = touches
        initialPosition = currentEntity?.transform
        self.isCancelled = false
        currentEntity = tappedEntity
    }

    @objc override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touchLocation = touches.first?.location(in: arView),
            let currentEntity = currentEntity else {
            return
        }
        self.event = event
        if  isCancelled {
         //   self.currentEntity?.transform = Transform()
        }
        print(currentEntity.position)
    }
    
    @objc override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if  isCancelled {
          //  self.currentEntity?.transform = Transform()
        }
        self.currentEntity = nil
    }
    
    @objc override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if isCancelled {
           // self.currentEntity?.transform = Transform()
        }
        self.currentEntity = nil
    }
    
}

extension ARViewManager {
    enum EntityNames: String {
        case stashedBall = "stashedBall"
        case filledBall = "filledBall"
        case table = "Table"
        case wall1 = "Wall1"
        case wall2 = "Wall2"
        case wall3 = "Wall3"
        case wall4 = "Wall4"
    }
    struct Constants {
        static let initialStashPosition: SIMD3<Float> = SIMD3<Float>(-0.3532956, 0.5906566, 0.3836859)
    }
}
class ARViewManager: NSObject, ObservableObject {
    
    private let disposeBag = DisposeBag()
    
    var arViewInitialized: PublishSubject<Void> = PublishSubject<Void>()

    typealias FilledBall = (Coordinate, Entity)
    var scene: ARGameComposer.ARGameScene!
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
    var cancelBag: Set<AnyCancellable> = []
    func configureAR() {
        guard let arView = self.arView else { return }
        scene = try! ARGameComposer.loadARGameScene()
        self.placement = scene.placement?.clone(recursive: true)
        scene.placement?.removeFromParent()
        arView.scene.anchors.append(scene)
        arView.isUserInteractionEnabled = true

        (scene.wall1?.children.first as? HasModel)?.model?.materials = [SimpleMaterial(color: .clear, isMetallic: true)]
        (scene.wall2?.children.first as? HasModel)?.model?.materials = [SimpleMaterial(color: .clear, isMetallic: true)]
        (scene.wall3?.children.first as? HasModel)?.model?.materials = [SimpleMaterial(color: .clear, isMetallic: true)]
        (scene.wall4?.children.first as? HasModel)?.model?.materials = [SimpleMaterial(color: .clear, isMetallic: true)]
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
            addedBall.name = EntityNames.filledBall.rawValue
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
    var isCancel: Bool = false
    var initialPosition: SIMD3<Float>?
    @objc func onTap(_ gesture: EntityTranslationGestureRecognizer) {
        switch gesture.state {
            
        case .possible:
            break
        case .began:
            self.isCancel = false
            self.initialPosition = gesture.entity?.position
            break
        case .changed:
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
    func addBall(isWhite: Bool, position: SIMD3<Float>) -> Entity {
        let ball = BallEntity(color: .white, position: position)
        let gesture = arView?.installGestures(.translation, for: ball)
        gesture?.first?.addTarget(self, action: #selector(self.onTap(_:)))
        
        scene.addChild(ball, preservingWorldTransform: true)
        return ball
    }
    
    func updateStashedItems(playerItems: [Ball]) {
        let itemsCount = playerItems.count
        for index in 0...(itemsCount - 1) {
            let i = floor(Float(index) / 3.0)
            let j = Int(index - Int(i) * 3)
           
            let addedBall = addBall(isWhite: true, position: [Constants.initialStashPosition.x + Float(j) * 0.09, Constants.initialStashPosition.y, Constants.initialStashPosition.z + Float(i) * 0.09])
            addedBall.name = EntityNames.stashedBall.rawValue
            addedBall.scene?.subscribe(to: CollisionEvents.Began.self, on: addedBall, { (event) in
                guard let entityName = EntityNames(rawValue: event.entityB.name) else { return }
                switch entityName {
                case .stashedBall:
                    break
                case .filledBall:
                    break
                case .table:
                    break
                case .wall1, .wall2, .wall3, .wall4:
                    self.isCancel = true
                }
            }).store(in: &cancelBag)
            addedBall.scene?.subscribe(to: CollisionEvents.Updated.self, on: addedBall, { (event) in
                print("efelflflfl")
            }).store(in: &cancelBag)

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

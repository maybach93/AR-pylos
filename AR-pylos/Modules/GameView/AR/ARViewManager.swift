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

extension ARViewManager {
    enum BallType {
        case white
        case black
        case availableToFill
    }
    enum EntityNames: String {
        case stashedBall = "stashedBall"
        case filledBall = "filledBall"
        case availableBall = "availableBall"
        case table = "Table"
    }
    struct Constants {
        static let initialStashPosition: SIMD3<Float> = SIMD3<Float>(-0.3532956, 0.5906566, 0.3836859)
        static let boundPosition: SIMD3<Float> = SIMD3<Float>(0, 0.66, 0.61180633)
        static let ballDiameter: Float = 0.08
        static let yTranslation: Float = 0.007
    }
}

class ARViewManager: NSObject, ObservableObject {
    
    private let disposeBag = DisposeBag()
    private var cancelBag: Set<AnyCancellable> = []
    
    var arViewInitialized: PublishSubject<Void> = PublishSubject<Void>()
    
    lazy private var gestureDelegate: ARGestureDelegate = {
        return ARGestureDelegate(arViewManager: self)
    }()
    
    typealias ItemCoordinate = (Coordinate, Entity)
    var scene: ARGameComposer.ARGameScene!
    private var placement: Entity!
    
    var sceneStashedBalls: [Entity] = []
    var sceneFilledBalls: [ItemCoordinate] = []
    var sceneAvailableToFill: [ItemCoordinate] = []
    var scenePlacements: [Entity] = []

    weak var arView: ARView? {
        didSet {
            guard arView != oldValue else { return }
            configureAR()
        }
    }
    
    private func configureAR() {
        guard let arView = self.arView else { return }
        scene = try! ARGameComposer.loadARGameScene()
        self.placement = scene.placement?.clone(recursive: true)
        scene.placement?.removeFromParent()
        arView.scene.anchors.append(scene)
        arView.isUserInteractionEnabled = true
        
        arViewInitialized.onNext(())
    }
    
    public func updateGameConfig(player: Player, map: [[WrappedMapCell]], stashedItems: [Player: [Ball]]) {
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
    private func updateStashedItems(playerItems: [Ball]) {
        let itemsCount = playerItems.count
        for index in 0...(itemsCount - 1) {
            let i = floor(Float(index) / 3.0)
            let j = Int(index - Int(i) * 3)
           
            let addedBall = addBall(isWhite: true, position: [Constants.initialStashPosition.x + Float(j) * 0.09, Constants.initialStashPosition.y, Constants.initialStashPosition.z + Float(i) * 0.09])
            addedBall.name = EntityNames.stashedBall.rawValue
            let gesture = arView?.installGestures(.translation, for: addedBall as! HasCollision)
            gesture?.first?.addTarget(gestureDelegate, action: #selector(gestureDelegate.onTap(_:)))
            self.sceneStashedBalls.append(addedBall)
        }
    }
    
    private func updatePlacement(mapWidth: Int) {
        for i in 0...(mapWidth - 1) {
            for j in 0...(mapWidth - 1) {
                let placement = self.placement.clone(recursive: true)
                placement.position = [self.placement.position.x + Float(i) * 0.08, self.placement.position.y, self.placement.position.z + Float(j) * 0.08]
                self.scenePlacements.append(placement)
                scene.addChild(placement, preservingWorldTransform: true)
            }
        }
    }
    
    private func updateMap(player: Player, map: [[WrappedMapCell]]) {
        
        func add(cell: WrappedMapCell, coordinate: Coordinate) {
            cell.item = Ball(owner: player)
            guard let item = cell.item else { return }
            guard coordinate.z < 2 else { return }
            let zeroPoint: SIMD3<Float> = [self.placement.position.x, self.placement.position.y + 0.04, self.placement.position.z]
            //isWhite: item.owner == player
            let addedBall = addBall(isWhite: coordinate.z == 0, position: [
                zeroPoint.x + ((Float(coordinate.x) + Float(coordinate.z) / 2.0) * 0.08),
                zeroPoint.y + Float(coordinate.z) * 0.057,
                zeroPoint.z + ((Float(coordinate.y) + Float(coordinate.z) / 2.0) * 0.08)])
            addedBall.name = coordinate.z == 1 ? EntityNames.availableBall.rawValue : EntityNames.filledBall.rawValue
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
    
    private func addBall(isWhite: Bool, position: SIMD3<Float>) -> Entity {
        let ball = BallEntity(color: isWhite ? .white: UIColor.green.withAlphaComponent(0.3), position: position, radius: Constants.ballDiameter / (isWhite ? 2 : 3))

        scene.addChild(ball, preservingWorldTransform: true)
        return ball
    }

}

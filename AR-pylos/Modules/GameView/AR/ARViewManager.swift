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
    
    var arViewInitialized: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var playerPickedItem: PublishSubject<Coordinate?> = PublishSubject<Coordinate?>()
    var playerPlacedItem: PublishSubject<(Coordinate?, Coordinate)> = PublishSubject<(Coordinate?, Coordinate)>()
    
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
    
    //MARK: - Public
    
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
    
    public func updatePlayerTurn(availableToMove: [Coordinate]) {
        scene.cube?.isEnabled = false
        self.arView?.gestureRecognizers?.forEach({ self.arView?.removeGestureRecognizer($0) })
        (self.sceneFilledBalls.filter({ availableToMove.contains($0.0) }).map({ $0.1 }) + self.sceneStashedBalls).forEach { (entity) in
            let gesture = arView?.installGestures(.translation, for: entity as! HasCollision)
            gesture?.first?.addTarget(gestureDelegate, action: #selector(gestureDelegate.onTap(_:)))
        }
    }
    
    public func updateWaitingState() {
        scene.cube?.isEnabled = true
        self.arView?.gestureRecognizers?.forEach({ self.arView?.removeGestureRecognizer($0) })
    }
    
    public func updateAvailablePoints(coordinates: [Coordinate]) {
        self.sceneAvailableToFill.forEach({ $0.1.removeFromParent() })
        self.sceneAvailableToFill.removeAll()
        
        coordinates.forEach { (coordinate) in
            let addedBall = addBall(type: .availableToFill, position: position(for: coordinate))
            addedBall.name = EntityNames.availableBall.rawValue
            self.sceneAvailableToFill.append((coordinate, addedBall))
        }
    }
    
    //MARK: - Internal
    
    internal func gestureFinishedTouch(entity: Entity, availablePlaced: Entity?) {
        guard let availablePlaced = availablePlaced else { return }
        guard let entityName = ARViewManager.EntityNames(rawValue: entity.name) else { return }
        switch entityName {
        case .stashedBall:
            guard let coordinate = self.sceneAvailableToFill.first(where: { $0.1 === availablePlaced })?.0 else { return }
            self.playerPlacedItem.onNext((nil, coordinate))
        case .filledBall:
            let coordinatePicked = self.sceneFilledBalls.first(where: { $0.1 === entity })?.0
            guard let coordinatePlaced = self.sceneAvailableToFill.first(where: { $0.1 === availablePlaced })?.0 else { return }
            self.playerPlacedItem.onNext((coordinatePicked, coordinatePlaced))
        default:
            break
        }
        self.updateAvailablePoints(coordinates: [])
    }
    
    internal func gestureBeganTouch(entity: Entity) {
        guard let entityName = ARViewManager.EntityNames(rawValue: entity.name) else { return }
        switch entityName {
        case .stashedBall:
            self.playerPickedItem.onNext(nil)
        case .filledBall:
            let coordinate = self.sceneFilledBalls.first(where: { $0.1 === entity })?.0
            self.playerPickedItem.onNext(coordinate)
        default:
            break
        }
    }
    //MARK: - Private
    
    private func configureAR() {
        guard let arView = self.arView else { return }
        scene = try! ARGameComposer.loadARGameScene()
        self.placement = scene.placement?.clone(recursive: true)
        scene.placement?.removeFromParent()
        arView.scene.anchors.append(scene)
        arView.isUserInteractionEnabled = true
        
        arViewInitialized.onNext(true)
    }
    
    private func updateStashedItems(playerItems: [Ball]) {
        let itemsCount = playerItems.count
        for index in 0...(itemsCount - 1) {
            let i = floor(Float(index) / 3.0)
            let j = Int(index - Int(i) * 3)
           
            let addedBall = addBall(type: .white, position: [Constants.initialStashPosition.x + Float(j) * 0.09, Constants.initialStashPosition.y, Constants.initialStashPosition.z + Float(i) * 0.09])
            addedBall.name = EntityNames.stashedBall.rawValue
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
    
    private func position(for coordinate: Coordinate) -> SIMD3<Float> {
        let zeroPoint: SIMD3<Float> = [self.placement.position.x, self.placement.position.y + 0.04, self.placement.position.z]
        return [
            zeroPoint.x + ((Float(coordinate.x) + Float(coordinate.z) / 2.0) * 0.08),
            zeroPoint.y + Float(coordinate.z) * 0.057,
            zeroPoint.z + ((Float(coordinate.y) + Float(coordinate.z) / 2.0) * 0.08)]
    }
    
    private func updateMap(player: Player, map: [[WrappedMapCell]]) {
        
        func add(cell: WrappedMapCell, coordinate: Coordinate) {
            guard let item = cell.item else { return }
            let addedBall = addBall(type: item.owner == player ? .white : .black, position: position(for: coordinate))
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
    
    private func addBall(type: BallType, position: SIMD3<Float>) -> Entity {
        let color: UIColor
        let size: Float
        switch type {
        case .white:
            color = .white
            size = Constants.ballDiameter / 2
        case .black:
            color = .black
            size = Constants.ballDiameter / 2
        case .availableToFill:
            color = UIColor.green.withAlphaComponent(0.3)
            size = Constants.ballDiameter / 3
        }
        let ball = BallEntity(color: color, position: position, radius: size)
        scene.addChild(ball, preservingWorldTransform: false)
        return ball
    }

}

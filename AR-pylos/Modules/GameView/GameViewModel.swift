//
//  GameViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    var router: Router
    @Published private(set) var state: State = .initial
    private let disposeBag = DisposeBag()
    private weak var coordinator: GameCoordinator? = GameProcess.instance.gameCoordinator
    @Published var arManager: ARViewManager = ARViewManager()
    init(router: Router) {
        self.router = router
    }
    func start() {
        arManager.arViewInitialized.subscribe { (event) in
            let player = Player(id: "r")
            let other = Player(id: "g")
            let game = Game(width: 4, playersAmount: 2)
            var map = game.map.map.map({ $0.map({ WrappedMapCell(cell: $0) })})
            self.arManager.updateGameConfig(player: Player(id: "r"), map: map, stashedItems: [player: [Ball(owner: player), Ball(owner: player)]])
        }.disposed(by: disposeBag)
        arManager.playerPickedItem.subscribe { [weak self] (event) in
            guard let payload = self?.coordinator?.currentServerPayload as? PlayerTurnServerPayload else { return }
            if let coordinate = event.element.unsafelyUnwrapped {
                self?.arManager.updateAvailablePoints(coordinates: payload.availableToMove?[coordinate] ?? [])
            }
            else {
                self?.arManager.updateAvailablePoints(coordinates: payload.availablePointsFromStash ?? [])
            }
        }.disposed(by: disposeBag)
    }
}

extension GameViewModel {
    enum State {
        case initial
    }
}

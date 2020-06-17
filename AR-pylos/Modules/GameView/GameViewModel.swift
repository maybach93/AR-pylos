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
    public var coordinator: GameCoordinator
    
    init(router: Router, coordinator: GameCoordinator) {
        self.router = router
        self.coordinator = coordinator
        coordinator.gameEnded.take(1).subscribe(onNext: { _ in self.gameEnd() }).disposed(by: disposeBag)
    }
    func start() {

    }
    func resetTracking() {
        coordinator.arManager.resetTracking()
    }
    func gameEnd() {
        self.state = .gameEnd
    }
    
    func exitGamePressed() {
        router.firstController = .main
    }
}

extension GameViewModel {
    enum State {
        case initial
        case gameEnd
    }
}

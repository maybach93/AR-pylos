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
    
    init(router: Router) {
        self.router = router
    }
    func start() {
        
    }
}

extension GameViewModel {
    enum State {
        case initial
    }
}

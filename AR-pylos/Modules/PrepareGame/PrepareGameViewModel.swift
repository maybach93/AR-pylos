//
//  PrepareGameViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

class PrepareGameViewModel: ObservableObject {
    var router: Router
    @Published private(set) var state: State = .initial
    private let disposeBag = DisposeBag()
    private weak var coordinator: GameCoordinator? = GameProcess.instance.gameCoordinator
    
    init(router: Router) {
        self.router = router
    }
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state = .game
        }
    }
}

extension PrepareGameViewModel {
    enum State {
        case initial
        case game
    }
}

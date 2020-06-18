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
    private var coordinator: GameCoordinator
    
    init(router: Router, coordinator: GameCoordinator) {
        self.coordinator = coordinator
        self.router = router
    }
    func start() {
        self.router.firstController = .rootView(AnyView(GameView(viewModel: GameViewModel(router: router, coordinator: coordinator))))
        self.state = .initial
    }
}

extension PrepareGameViewModel {
    enum State {
        case initial
        case game(GameCoordinator)
    }
}

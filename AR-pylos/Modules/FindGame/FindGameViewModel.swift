//
//  FindGameViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/10/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

class FindGameViewModel: ObservableObject {
    var router: Router
    @Published private(set) var state: State = .initial
    private var disposeBag = DisposeBag()
    private var matchingCoordinator: GameMatchingCoordinator?
    
    deinit {
        print("")
    }
    init(router: Router) {
        self.router = router
    }
    func start(isHost: Bool) {
        self.matchingCoordinator = GameMatchingCoordinator(connectionType: .bluetooth(isHost: isHost))
        state = .bluetooth(isHost)

        self.matchingCoordinator?.findGame().subscribe(onSuccess: { [weak self] (coordinator) in
            guard let self = self else { return }
            self.router.firstController = .rootView(AnyView(GameView(viewModel: GameViewModel(router: self.router, coordinator: coordinator))))
        }).disposed(by: disposeBag)
    }
    func onDissapear() {
        self.matchingCoordinator = nil
        self.disposeBag = DisposeBag()
        self.state = .initial
    }
}

extension FindGameViewModel {
    enum State {
        case initial
        case bluetooth(Bool)
        case gameCenter
    }
}

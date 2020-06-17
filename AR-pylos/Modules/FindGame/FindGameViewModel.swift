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
    private let disposeBag = DisposeBag()
    private var matchingCoordinator: GameMatchingCoordinator?
    
    init(router: Router) {
        self.router = router
    }
    func start(isHost: Bool) {
        self.matchingCoordinator = GameMatchingCoordinator(connectionType: .bluetooth(isHost: isHost))
        state = .gameCenter
        self.matchingCoordinator?.findGame().subscribe(onSuccess: { self.router.firstController = .game($0) }).disposed(by: disposeBag)
    }
}

extension FindGameViewModel {
    enum State {
        case initial
        case bluetooth
        case gameCenter
    }
}

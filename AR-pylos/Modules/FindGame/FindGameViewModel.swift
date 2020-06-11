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
    func start() {
        self.matchingCoordinator = GameMatchingCoordinator(connectionType: .gameKit)
        state = .gameCenter
        self.matchingCoordinator?.findGame().subscribe(onNext: { (isHost) in
            
            self.router.firstController = .game
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension FindGameViewModel {
    enum State {
        case initial
        case bluetooth
        case gameCenter
    }
}

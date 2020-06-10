//
//  FindGameViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/10/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation


class FindGameViewModel: ObservableObject {
    
    @Published private(set) var state: State = .initial

    private let disposeBag = DisposeBag()
    private var matchingCoordinator: GameMatchingCoordinator?
    
    init() {
        
    }
    func start() {
        self.matchingCoordinator = GameMatchingCoordinator(connectionType: .gameKit)
        state = .gameCenter
        self.matchingCoordinator?.findGame().subscribe(onNext: { (obs) in
            print("ll")
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

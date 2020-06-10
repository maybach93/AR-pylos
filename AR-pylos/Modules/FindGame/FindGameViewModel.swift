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

    private var matchingCoordinator: GameMatchingCoordinator? 
    init() {
        
    }
    func start() {
        state = .gameCenter("test")
    }
}

extension FindGameViewModel {
    enum State {
        case initial
        case bluetooth
        case gameCenter(String)
    }
}

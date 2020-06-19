//
//  SettingsViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/18/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    var router: Router
    @Published private(set) var state: State = .initial
    private let disposeBag = DisposeBag()
    private let repository: LocalRepository = LocalRepository()
    
    @Published private var nameRaw = ""
    @Published private var yourSelectedColorIndexRaw = 0
    @Published private var opponentSelectedColorIndexRaw = 1
    
    var name: Binding<String> {
        return Binding<String>(get: { return self.nameRaw }, set: {
            self.nameRaw = $0
        })
    }
    
    var yourSelectedColorIndex: Binding<Int> {
        return Binding<Int>(get: { return self.yourSelectedColorIndexRaw }, set: {
            if $0 == self.opponentSelectedColorIndexRaw {
                self.opponentSelectedColorIndexRaw = self.yourSelectedColorIndexRaw
            }
            self.yourSelectedColorIndexRaw = $0
        })
    }
    var opponentSelectedColorIndex: Binding<Int> {
        return Binding<Int>(get: { return self.opponentSelectedColorIndexRaw }, set: {
            if $0 == self.yourSelectedColorIndexRaw {
                self.yourSelectedColorIndexRaw = self.opponentSelectedColorIndexRaw
            }
            self.opponentSelectedColorIndexRaw = $0
        })
    }
    
    init(router: Router) {
        self.router = router
        self.yourSelectedColorIndexRaw = self.repository.get(Int.self, LocalRepository.Keys.playerColor) ?? 0
        self.opponentSelectedColorIndexRaw = self.repository.get(Int.self, LocalRepository.Keys.opponentColor) ?? 1
        self.nameRaw = self.repository.get(String.self, LocalRepository.Keys.playerName) ?? ""
    }
    func onDissapear() {
        self.state = .initial
        self.repository.set(value: yourSelectedColorIndexRaw, LocalRepository.Keys.playerColor)
        self.repository.set(value: opponentSelectedColorIndexRaw, LocalRepository.Keys.opponentColor)
        self.repository.set(value: nameRaw, LocalRepository.Keys.playerName)
    }
    
}

extension SettingsViewModel {
    enum State {
        case initial
    }
}

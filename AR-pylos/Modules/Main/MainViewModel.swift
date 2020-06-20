//
//  MainViewModel.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/19/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

struct MainViewModel {
    private let repository: LocalRepository = LocalRepository()
    var showOnboarding: Bool {
        get {
            if repository.get(Bool.self, .showOnboarding) == nil {
                repository.set(value: true, .showOnboarding)
                return true
            }
            else {
                return false
            }
        }
    }
}

//
//  MainView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/8/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init() {
        
    }
    var body: some View {
        switch router.firstController {
        case .main:
            return AnyView(NavigationView {
                HStack {
                    VStack {
                        Text("Pylos").font(.system(size: 80, weight: .thin, design: .default))
                        Spacer(minLength: 80)
                        NavigationLink(destination: FindGameView(viewModel: FindGameViewModel(router: router))) {
                            Text("Start a new game")
                            }.isDetailLink(false).padding(20)
                        NavigationLink(destination: SettingsView(viewModel: SettingsViewModel(router: router))) {
                            Text("Settings")
                            }.isDetailLink(false).padding(20)
                    }
                }
            })
        case .find(let findGameViewModel):
            return AnyView(NavigationView {
                FindGameView(viewModel: findGameViewModel)
            })
        case .rootView(let view):
            return AnyView(NavigationView {
                view
            })
        case .game(let coordinator):
            return AnyView(NavigationView {
                PrepareGameView(viewModel: PrepareGameViewModel(router: router, coordinator: coordinator))
            })
        }
    }
}

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
    @State private var startNewGame: Bool = false
    
    init() {
        
    }
    var body: some View {
        switch router.firstController {
        case .main:
            return AnyView(NavigationView {
                HStack {
                    NavigationLink(destination: FindGameView(viewModel: FindGameViewModel()), isActive: self.$startNewGame) {
                        EmptyView()
                    }.isDetailLink(false)
                    Button("start a new game") {
                        self.startNewGame = true
//                        self.router.firstController = .rootView(AnyView(FindGameView(viewModel: FindGameViewModel())))
                    }
                }.onAppear {
                    self.startNewGame = false
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
        default:
            return AnyView(NavigationView {
                NavigationLink(destination: FindGameView(viewModel: FindGameViewModel()), isActive: self.$startNewGame) {
                    EmptyView()
                }.isDetailLink(false)
                Button("start a new game") {
                    self.startNewGame = true
                }
            })
        }
    }
}

//
//  PrepareGameView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct PrepareGameView: View {
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: PrepareGameViewModel
    
    
    init(viewModel: PrepareGameViewModel) {
        self.viewModel = viewModel
    }
    
    private var content: some View {
        switch viewModel.state {
        case .initial:
            return AnyView(NavigationView {
                HStack(content: {
                    Text("game is being started...")
                })
            }.onAppear {
                self.viewModel.start()
            })
        case .game(let coordinator):
            return AnyView(NavigationView {
                GameView(viewModel: GameViewModel(router: router, coordinator: coordinator))
            })
        }
    }
    var body: some View {
        return content
    }
}


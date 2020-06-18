//
//  FindGameView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/10/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct FindGameView: View {
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FindGameViewModel
    
    
    init(viewModel: FindGameViewModel) {
        self.viewModel = viewModel
    }
    
    private var content: some View {
        switch viewModel.state {
        case .initial:
            return AnyView(NavigationView {
                HStack(content: {
                    Button("Create connection") {
                        self.viewModel.start(isHost: true)
                    }
                    Button("Look for players") {
                        self.viewModel.start(isHost: false)
                    }
                })
            }).onDisappear {
                self.viewModel.onDissapear()
            }
        case .bluetooth:
            return AnyView(NavigationView {
                Text("looking for teammate")
            }).onDisappear {
                self.viewModel.onDissapear()
            }
        case .gameCenter:
            return AnyView(NavigationView {
                Text("looking for teammate...")
            }).onDisappear {
                self.viewModel.onDissapear()
            }
        }
    }
    var body: some View {
        return content
    }
}


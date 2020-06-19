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
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        self.viewModel.start(isHost: true)
                    }) {
                        ZStack {
                            Rectangle().fill(Color.orange.opacity(0.8))
                            Text("Create game")
                                .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 200)
                                .font(.title).foregroundColor(Color.black.opacity(0.6))
                        }
                    }
                    Button(action: {
                        self.viewModel.start(isHost: false)
                    }) {
                        ZStack {
                            Rectangle().fill(Color.green.opacity(0.8))
                            Text("Join game")
                                .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 200)
                                .font(.title).foregroundColor(Color.black.opacity(0.6))
                        }
                    }
                    }.edgesIgnoringSafeArea(.all)
                }.navigationBarTitle("Start game")).onDisappear {
                self.viewModel.onDissapear()
            }
        case .bluetooth(let isHost):
            return AnyView(NavigationView {
                ZStack {
                    if isHost {
                        Color.orange.opacity(0.8).edgesIgnoringSafeArea(.all)
                    }
                    else {
                        Color.green.opacity(0.8).edgesIgnoringSafeArea(.all)
                    }
                    VStack {
                        Text("Searching for nearby players")
                        ActivityIndicator()
                            .frame(width: 100, height: 100)
                    }.foregroundColor(Color.white)
                }
            }.navigationBarTitle("Start game")).onDisappear {
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


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
                VStack(content: {
                    Button("Create game") {
                        self.viewModel.start(isHost: true)
                    }.padding(20)
                    Button("Join game") {
                        self.viewModel.start(isHost: false)
                    }.padding(20)
                })
                }.navigationBarTitle("Start game")).onDisappear {
                self.viewModel.onDissapear()
            }
        case .bluetooth:
            return AnyView(NavigationView {
                ZStack {
                    Color.green.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("looking for teammate")
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


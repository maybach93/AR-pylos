//
//  GameView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct GameView: View {
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    private var content: some View {
        switch viewModel.state {
        case .initial, .gameEnd:
            return AnyView(NavigationView {
                ZStack(content: {
                    ARDisplayView(arViewManager: self.viewModel.coordinator.arManager)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if viewModel.state == .gameEnd {
                                Button("exit game") {
                                    self.viewModel.exitGamePressed()
                                }
                            }
                            else {
                                Button("reset tracking") {
                                    self.viewModel.resetTracking()
                                }
                            }
                        }
                    }
                })
            }).onAppear {
                self.viewModel.start()
            }
        }
    }
    var body: some View {
        return content
    }
}


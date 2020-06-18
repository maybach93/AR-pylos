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
    @State private var exitAlert = false

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
                                Button("Exit game") {
                                    self.viewModel.exitGamePressed()
                                }
                            }
                            else {
                                Button("Exit game") {
                                    self.exitAlert = true
                                }.alert(isPresented: $exitAlert) {
                                    Alert(title: Text("Confirm exit current game"), primaryButton: Alert.Button.default(Text("Confirm"), action: {
                                        self.viewModel.exitGamePressed()
                                    }), secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                                        self.exitAlert = false
                                    }))
                                }
                                Button("Reset tracking") {
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


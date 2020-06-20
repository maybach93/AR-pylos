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
    let arView: ARDisplayView
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        self.arView = ARDisplayView(arViewManager: viewModel.coordinator.arManager)
    }
    
    private var content: some View {
        
        switch viewModel.state {
        case .initial, .gameEnd:
            return AnyView(NavigationView {
                ZStack(content: {
                    arView
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if viewModel.state == .gameEnd {
                                Button(action: {
                                    self.viewModel.exitGamePressed()
                                }) {
                                    Text("Exit game")
                                    .fontWeight(.light)
                                    .font(.footnote)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black.opacity(0.5), lineWidth: 1)
                                    )
                                }.padding(.trailing, 5)
                            }
                            else {
                                Button(action: {
                                    self.exitAlert = true
                                }) {
                                    Text("Exit game")
                                    .fontWeight(.light)
                                    .font(.footnote)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black.opacity(0.5), lineWidth: 1)
                                    )
                                }.alert(isPresented: $exitAlert) {
                                    self.viewModel.coordinator.arManager.arView?.session.pause()
                                    return Alert(title: Text("Confirm exit current game"), primaryButton: Alert.Button.default(Text("Confirm"), action: {
                                        self.viewModel.exitGamePressed()
                                    }), secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                                        self.exitAlert = false
                                        if let configuration = self.viewModel.coordinator.arManager.arView?.session.configuration {
                                            self.viewModel.coordinator.arManager.arView?.session.run(configuration)
                                        }
                                    }))
                                }
                                Button(action: {
                                    self.viewModel.resetTracking()
                                }) {
                                    Text("Reset tracking")
                                    .fontWeight(.light)
                                    .font(.footnote)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(20)
                                }.padding(.trailing, 5)
                            }
                        }.padding(.bottom, 10)
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


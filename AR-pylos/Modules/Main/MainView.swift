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

    @State var showOnboarding: Bool = false
    init() {
        self.viewModel = MainViewModel()
        self.showOnboarding = viewModel.showOnboarding
    }
    var viewModel = MainViewModel()
    var body: some View {
        
        switch router.firstController {
        case .main:
            return AnyView(NavigationView {
                ZStack {
                    VideoPlayerView(url: Bundle.main.url(forResource: "video", withExtension: "mov"))
                        .overlay(Color.white.opacity(0.3))
                        .blur(radius: 3)
                        .edgesIgnoringSafeArea(.all)
                    HStack {
                        VStack(alignment: .center, spacing: 20) {
                            HStack {
                                Spacer()
                                Text("Pylos").font(.system(size: 100, weight: .thin, design: .default)).padding(40)
                            }
                            
                            Spacer()
                            NavigationLink(destination: FindGameView(viewModel: FindGameViewModel(router: router))) {
                                Text("Play")
                                    .fontWeight(.regular)
                                    .font(.title)
                                    .padding([.leading, .trailing], 60)
                                    .padding([.top, .bottom], 20)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(40)
                
                                }.isDetailLink(false)
                            NavigationLink(destination: SettingsView(viewModel: SettingsViewModel(router: router))) {
                                Text("Settings")
                                    .fontWeight(.medium)
                                    .font(.headline)
                                    .padding([.leading, .trailing], 40)
                                    .padding([.top, .bottom], 10)
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .cornerRadius(40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                                ).padding(.bottom, 10)
                                }.isDetailLink(false)
                        }
                    }
                }
            }.sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }.onAppear(perform: {
                if self.viewModel.showOnboarding {
                    self.showOnboarding = true
                }
            }))
        case .find(let findGameViewModel):
            return AnyView(NavigationView {
                FindGameView(viewModel: findGameViewModel)
            })
        case .rootView(let view):
            return AnyView(NavigationView {
                view
            })
        }
    }
}

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
        NavigationView {
            HStack(content: {
                
                if router.firstController == .main {
                    NavigationLink(destination: FindGameView(viewModel: FindGameViewModel()), isActive: self.$startNewGame) {
                        EmptyView()
                    }.isDetailLink(false)
                    Button("start a new game") {
                        self.startNewGame = true
                    }.transition(.opacity)
                }
                else if router.firstController == .prepare {
                    
                }
            
                    
            }).onReceive(router.popToRoot) { (out) in
              //  self.openDetails = false
            }.onAppear {
                self.startNewGame = false
            }
        }
    }
}

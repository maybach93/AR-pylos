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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: FindGameViewModel = FindGameViewModel()
    
    
    init(viewModel: FindGameViewModel) {
        self.viewModel = viewModel
    }
    
    private var content: some View {
        switch viewModel.state {
        case .initial:
            return AnyView(NavigationView {
                HStack(content: {
                    Button("Game via bluetooth") {
                        self.viewModel.start()
                    }
                    Button("Find via Game center") {
                        //self.startNewGame = true
                    }
                })
            })
        case .bluetooth:
            return AnyView(NavigationView {
                Text("looking for teammate")
            })
        case .gameCenter(let str):
            return AnyView(NavigationView {
                Text("looking for teammate \(str)")
            })
        }
    }
    var body: some View {
        return content
    }
}


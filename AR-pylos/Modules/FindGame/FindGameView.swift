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
    @State private var startNewGame: Bool = false
    
    init(viewModel: FindGameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(content: {
            Button("Game via bluetooth") {
                self.startNewGame = true
            }
            Button("Find via Game center") {
                self.startNewGame = true
            }
        })
    }
}


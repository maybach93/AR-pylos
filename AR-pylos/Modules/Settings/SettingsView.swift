//
//  SettingsView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/18/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: SettingsViewModel
    
    @State private var colors = [ "⚪","⚫","🔴","🟠","🟣"]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    private var content: some View {
        switch viewModel.state {
        case .initial:
            return AnyView(NavigationView {
                HStack(content: {
                    VStack {
                        Text("Your ball color").padding()
                        Picker("Colors", selection: self.viewModel.yourSelectedColorIndex) {
                            ForEach(0 ..< colors.count) { index in
                                Text(self.colors[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Text("Opponent ball color").padding()
                        Picker("Colors", selection: self.viewModel.opponentSelectedColorIndex) {
                            ForEach(0 ..< colors.count) { index in
                                Text(self.colors[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Spacer()
                        // 3.
                        
                    }
                })
            }.navigationBarTitle("Settings").onDisappear(perform: {
                self.viewModel.onDissapear()
            }))
        }
    }
    var body: some View {
        return content
    }
}


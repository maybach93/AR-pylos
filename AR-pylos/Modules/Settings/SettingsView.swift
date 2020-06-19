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
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your name").padding([.leading, .trailing], 10)
                        TextField("Enter your name", text: self.viewModel.name).padding([.leading, .trailing, .bottom], 10).font(.title).foregroundColor(Color.green.opacity(0.8))
                        Text("Your ball color").padding([.leading, .trailing], 10)
                        Picker("Colors", selection: self.viewModel.yourSelectedColorIndex) {
                            ForEach(0 ..< colors.count) { index in
                                Text(self.colors[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()).padding([.leading, .trailing, .bottom], 10)
                        Text("Opponent ball color").padding([.leading, .trailing], 10)
                        Picker("Colors", selection: self.viewModel.opponentSelectedColorIndex) {
                            ForEach(0 ..< colors.count) { index in
                                Text(self.colors[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()).padding([.leading, .trailing, .bottom], 10)
                        
                    }
                    Spacer()
                }
                    
                
            }.navigationBarTitle("Settings").onDisappear(perform: {
                self.viewModel.onDissapear()
            }))
        }
    }
    var body: some View {
        return content
    }
}


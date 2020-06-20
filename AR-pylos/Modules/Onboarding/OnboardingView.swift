//
//  OnboardingView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/19/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                Spacer()

                VStack {
                    Text("Welcome to")
                        .fontWeight(.regular)
                        .font(.title)
                        .foregroundColor(.black)

                    Text("AR Pylos Game")
                        .fontWeight(.thin)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }.padding(.top, 20)
                OnboardingContainerView()

                Spacer(minLength: 30)

                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Continue").modifier(OnboardingButton())
                }
                .padding(.horizontal)
            }
        }
    }
}

//
//  OnboardingItemView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/19/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

struct OnboardingItemView: View {
    var title: String
    var subTitle: String
    var number: String

    var body: some View {
        HStack(alignment: .center) {
            Text(number)
            .font(.title)
            .foregroundColor(.primary)
            .accessibility(addTraits: .isHeader)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}


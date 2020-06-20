//
//  OnboardingContainerView.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/19/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import SwiftUI

struct OnboardingContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            OnboardingItemView(title: "Object of the Game", subTitle: "This is a two players game. \nPlayers attempt to build a pyramid by stacking the 30 spheres.", number: "1")
            OnboardingItemView(title: "Game play", subTitle: "Each player alternately, puts a sphere from his reserve into any hollow which he has chosen.\nWhen one or more squares of spheres are formed on the board, a player can choose to stack one of his spheres on it. He then has a choice: \na) taking a sphere from his reserve\nb) placing a sphere from his reserve on one of the squares of spheres\nc) moving one of his spheres already on the board and putting it on a square of spheres, but only if this move raises his sphere by one or more levels.", number: "2")

            OnboardingItemView(title: "Winner", subTitle: "At the end of the game, the game board should have 4 levels. A player wins if they put the last piece on the 4th level, or if the other player runs out of pieces to play", number: "3")
        }
        .padding(.horizontal)
    }
}

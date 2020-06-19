//
//  Router.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/10/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum Controllers {
    case main
    case find(FindGameViewModel)
    case rootView(AnyView)
}

final class Router: ObservableObject {
    let popToRoot = PassthroughSubject<(), Never>()
    @Published var firstController: Controllers = .main
}

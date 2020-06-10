//
//  Router.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/10/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import Combine

enum Controllers: Equatable {
    case main
    case game
    case prepare
}

final class Router: ObservableObject {
    let popToRoot = PassthroughSubject<(), Never>()
    @Published var firstController: Controllers = .main
}

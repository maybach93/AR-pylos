//
//  ArrayExtension.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func next(current: Element) -> Element? {
        guard let index = self.firstIndex(of: current) else { return nil }
        if index == self.count - 1 {
            return self.first
        }
        else {
            return self[index + 1]
        }
    }
}

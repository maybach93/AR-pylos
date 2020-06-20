//
//  LocalRepository.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/18/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

extension LocalRepository {
    enum Keys: String {
        case playerColor
        case opponentColor
        case showOnboarding
        case playerName
    }
}
class LocalRepository {
    private var storage: UserDefaults = UserDefaults.standard
    
    func get<T>(_ type: T.Type, _ key: Keys) -> T? {
        return storage.object(forKey: key.rawValue) as? T
    }
    func set(value: Any, _ key: Keys) {
        return storage.set(value, forKey: key.rawValue)
    }
    func remove(_ key: Keys) {
        return storage.removeObject(forKey: key.rawValue)
    }
}

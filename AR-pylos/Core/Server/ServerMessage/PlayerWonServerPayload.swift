//
//  PlayerWonServerPayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

struct PlayerWonServerPayload: ServerMessagePayloadProtocol {
    var player: Player
    
    var winner: Player
}

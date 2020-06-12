//
//  InitiatedPlayerMessagePayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

struct InitiatedPlayerMessagePayload: PlayerMessagePayloadProtocol {
    var playerId: String
    var playerName: String
}

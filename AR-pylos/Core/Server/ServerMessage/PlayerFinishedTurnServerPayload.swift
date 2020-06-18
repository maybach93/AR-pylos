//
//  PlayerFinishedTurnServerPayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

struct PlayerFinishedTurnServerPayload: ServerMessagePayloadProtocol {
    var player: Player
    
    var currentPlayer: Player
    var fromCoordinate: Coordinate? //Return nil if taken from stash
    var toCoordinate: Coordinate
    var item: Ball
    
    var gameConfig: GameConfigServerPayload
}

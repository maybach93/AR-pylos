//
//  PlayerFinishedTurnMessagePayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

struct PlayerFinishedTurnMessagePayload: PlayerMessagePayloadProtocol {
    var player: Player
   
    var fromCoordinate: Coordinate? //Return nil if taken from stash
    var toCoordinate: Coordinate
    var item: Ball
}

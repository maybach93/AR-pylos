//
//  PlayerTurnServerPayload.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/12/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

struct PlayerTurnServerPayload: ServerMessagePayloadProtocol {
    var player: Player
    
    var isPlayerTurn: Bool
    var availableToMove: [Coordinate: [Coordinate]]? //Array of available points to move, and where those poins can be moved
    //Array of points to place (but if player picks a ball that formed a 4X4, the second lvl of that 4X4 is no longer available and should be deducted from availablePoints) RULE: if availablePoints.$0.parents.{ $0.ball == movedCoordinate.ball }
    var availablePointsFromStash: [Coordinate]? // Array of all points available to fill (from stash)
    
    init(player: Player, isPlayerTurn: Bool, availableToMove: [Coordinate: [Coordinate]]?, availablePointsFromStash: [Coordinate]?) {
        self.player = player
        self.isPlayerTurn = isPlayerTurn
        self.availableToMove = availableToMove
        self.availablePointsFromStash = availablePointsFromStash
    }
}

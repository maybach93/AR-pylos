//
//  GameServer.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/5/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

//This protocol is the interface between server and players.
//It receives actions/signals from server to update information or UI
//It sends user actions to server locally or via Network

protocol GameServerBridgeOutputs {
    //observable - player actions
    //left the game
}

protocol GameServerBridgeInputs {
    //observable - other players' actions
    //server update state of game
}

protocol GameServerBridge {
    var player: Player { get }
}

class GameServer {
    private var gameBridges: [GameServerBridge]
    
    init(gameBridges: [GameServerBridge]) {
        self.gameBridges = gameBridges
    }
}

//
//  GameProcess.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class GameProcess {
    var server: GameServerProtocol?
    
    static var instance = GameProcess()
    
    func terminate() {
        //Send command to server and GameCoordinator to stop game
        self.server = nil
    }
    
    func terminateServer() {
        self.server = nil
    }
    
    func host(server: GameServerProtocol) {
        self.server = server
    }
}


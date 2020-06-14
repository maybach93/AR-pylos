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
    var gameCoordinator: GameCoordinator?
    
    static var instance = GameProcess()
    
    func terminate() {
        //Send command to server and GameCoordinator to stop game
        self.server = nil
        self.gameCoordinator = nil
    }
    
    func terminateServer() {
        self.server = nil
    }
    
    func host(server: GameServerProtocol) {
        self.server = server
    }
    
    func startProcess(coordinator: GameCoordinator) {
        self.gameCoordinator = coordinator
    }
}


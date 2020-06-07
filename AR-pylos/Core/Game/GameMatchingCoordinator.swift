//
//  GameMatchingCoordinator.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

//*
//This class is created whenever user taps Create/Join game either via Bluetooth or GameKit.
//This class is responsible for matching process and game creation. Once matching is finished,
//GameMatchingCoordinator creates GameCoordinator and GameServer(for Host). Also it creates LocalPlayerServerAdapter (for host) and RemotePlayerServerAdapter for remote player
import Foundation

enum ConnectionType {
    case bluetooth, gameKit
}

class GameMatchingCoordinator {
    
    private var asHost: Bool?
    var communicator: CommunicatorAdapter
    
    init(connectionType: ConnectionType) {
        switch connectionType {
        case .gameKit:
            communicator = GameKitNetworkAdapter()
        default:
            communicator = BluetoothNetworkAdapter()
        }
    }
    
    func match(asHost: Bool) {
        self.asHost = asHost
        communicator.findMatch(asHost: asHost)
    }
    
    func foundGame() {
        let coordinator = GameCoordinator()
        if asHost ?? false {
            let remotePlayerCoordinator = RemotePlayerServerBridge()
            
            GameProcess.instance.host(server: GameServer(gameCoordinators: [coordinator, remotePlayerCoordinator]))
        }
        else {
            GameProcess.instance.host(server: RemoteServerBridge(coordinator: coordinator))
        }
    }
}

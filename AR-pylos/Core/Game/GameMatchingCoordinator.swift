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
    case bluetooth(isHost: Bool), gameKit
}

struct GameStartChallengeModel: Codable {
    var time: TimeInterval
    init() {
        self.time = Date.timeIntervalSinceReferenceDate
    }
}

class GameMatchingCoordinator {
    
    private let disposeBag = DisposeBag()

    var communicator: CommunicatorAdapter
    var isHost: Bool = false
    init(connectionType: ConnectionType) {
        switch connectionType {
        case .gameKit:
            communicator = GameKitNetworkAdapter()
        case .bluetooth(let isHost):
            if isHost {
                self.isHost = true
                communicator = CentralBluetoothNetworkAdapter()
            }
            else {
                communicator = PeripheralBluetoothNetworkAdapter()
            }
        }
    }
    
    func findGame() -> Single<GameCoordinator> {
        return self.communicator.findMatch().flatMap({ _ in self.foundGame() })
    }
    
    private func foundGame() -> Single<GameCoordinator> {
        return Single<GameCoordinator>.create { (observer) -> Disposable in
            let coordinator = GameCoordinator()
            if self.isHost {
                let remotePlayerCoordinator = RemotePlayerServerBridge(communicator: self.communicator)
                GameProcess.instance.host(server: GameServer(gameCoordinators: [coordinator, remotePlayerCoordinator]))
                observer(.success(coordinator))
            }
            else {
                GameProcess.instance.host(server: RemoteServerBridge(communicator: self.communicator, coordinator: coordinator))
                observer(.success(coordinator))
            }
            return Disposables.create {}
        }
    }
}

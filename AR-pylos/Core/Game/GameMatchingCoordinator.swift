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

struct GameStartChallengeModel: Codable {
    var time: TimeInterval
    init() {
        self.time = Date.timeIntervalSinceReferenceDate
    }
}

class GameMatchingCoordinator {
    
    private let disposeBag = DisposeBag()

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
        communicator.findMatch().subscribe(onNext: { (result) in
            self.foundGame()
        }, onError: { (error) in
            
        }, onCompleted: {
        
            }, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func foundGame() {
        let challenge = GameStartChallengeModel()
        guard let challengeData = try? JSONEncoder().encode(challenge) else { return }
        communicator.outMessages.accept(challengeData)
        communicator.inMessages.subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let responseData):
                guard let chanllengeResponseModel = try? JSONDecoder().decode(GameStartChallengeModel.self, from: responseData) else { return }

                let coordinator = GameCoordinator()
                if challenge.time > chanllengeResponseModel.time  {
                    let remotePlayerCoordinator = RemotePlayerServerBridge(communicator: self.communicator)
                    
                    GameProcess.instance.host(server: GameServer(gameCoordinators: [coordinator, remotePlayerCoordinator]))
                }
                else {
                    GameProcess.instance.host(server: RemoteServerBridge(coordinator: coordinator))
                }
            case .error(_):
                break
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
}

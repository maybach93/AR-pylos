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
    
    init(connectionType: ConnectionType) {
        switch connectionType {
        case .gameKit:
            communicator = GameKitNetworkAdapter()
        case .bluetooth(let isHost):
            if isHost {
                communicator = BluetoothNetworkAdapter()
            }
            else {
                communicator = PeripheralBluetoothNetworkAdapter()
            }
        }
    }
    
    func findGame() -> Single<Bool> {
        return self.communicator.findMatch().flatMap({ _ in self.foundGame() })
    }
    
    private func foundGame() -> Single<Bool> {
        return Single.create { (observer) -> Disposable in
            let challenge = GameStartChallengeModel()
            guard let challengeData = try? JSONEncoder().encode(challenge) else {
                observer(.success(false))
                return Disposables.create {}
            }
            self.communicator.outMessages.accept(challengeData)
            self.communicator.inMessages.subscribe { [weak self] (event) in
                guard let self = self else { return }
                switch event {
                case .next(let responseData):
                    guard let chanllengeResponseModel = try? JSONDecoder().decode(GameStartChallengeModel.self, from: responseData) else { return }

                    let coordinator = GameCoordinator()
                    if challenge.time < chanllengeResponseModel.time {
                        let remotePlayerCoordinator = RemotePlayerServerBridge(communicator: self.communicator)
                        
                        GameProcess.instance.host(server: GameServer(gameCoordinators: [coordinator, remotePlayerCoordinator]))
                        observer(.success(true))
                    }
                    else {
                        GameProcess.instance.host(server: RemoteServerBridge(communicator: self.communicator, coordinator: coordinator))
                        observer(.success(false))
                    }
                case .error(_):
                    break
                case .completed:
                    break
                }
            }.disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }
}

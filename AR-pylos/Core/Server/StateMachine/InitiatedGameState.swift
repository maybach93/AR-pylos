//
//  InitiatedGameState.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

class InitiatedGameState: BaseGameState {
    
    override var state: GameStateMachine {
        return .initiated
    }
    
    func movingFrom(previousState: BaseGameState) {
        Observable.zip(self.context.gameCoordinators.values.map({ $0.playerStateMessage.asObservable() })).subscribe({ (event) in
            switch event {
            case .next(let response):
                for player in response {
                    self.context.gameCoordinators.keys.first(where: { $0.id == player.payload.playerId })?.playerName = (player.payload as? InitiatedPlayerMessagePayload)?.playerName
                }
            default:
                break
            }
            }).disposed(by: disposeBag)
        self.context.gameCoordinators.keys.forEach({ self.context.gameCoordinators[$0]?.serverStateMessages.accept(ServerMessage(type: .initiated, payload: InitiatedServerMessagePayload(playerId: $0.id))) })
    }
}

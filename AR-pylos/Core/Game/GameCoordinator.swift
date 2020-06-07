//
//  GameCoordinator.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

//This class is created after matching process. It coordinates UI and available action for current player, opens win/lose screen etc.
//it subscribes for server acrtion, and emit actions from player to server
import Foundation

protocol GameCoordinatorBridgeProtocol: class, GameCoordinatorInputProtocol, GameCoordinatorOutputProtocol {
}
protocol GameCoordinatorInputProtocol {
    //Interface to receive actions from server
    var otherPlayersActions: Observable<String> { get }
}
protocol GameCoordinatorOutputProtocol {
    //Interface to send actions to server (player actions)
    var playerAction: PublishSubject<Void> { get }
}

class GameCoordinator: GameCoordinatorBridgeProtocol {
    var playerAction: PublishSubject<Void> = PublishSubject<Void>()
    var otherPlayersActions: Observable<String> = Observable<String>.just("")
    
    init() {
        
    }
}

//
//  GameKitNetworkAdapter.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

//Low level interface to find and handle connection
import Foundation
import GameKit

protocol CommunicatorAdapter {
    var outMessages: PublishRelay<Data> { get } //Messages to send to others
    var inMessages: PublishSubject<Data> { get } //Messages received from others
    
    func findMatch() -> Single<Void>
}

class GameKitNetworkAdapter: CommunicatorAdapter {
    
    private let disposeBag = DisposeBag()
    
    private let localPlayer = GKLocalPlayer()
    
    var outMessages: PublishRelay<Data> = PublishRelay<Data>() //Messages to send to others
    var inMessages: PublishSubject<Data> = PublishSubject<Data>() //Messages received from others
    
    init() {
        localPlayer.authenticateHandler = { (vc, error) in
        }
    }
    
    func findMatch() -> Single<Void> {
        return Single<Void>.create { (observer) -> Disposable in
            self.createBindings()
            return Disposables.create {}
        }
    }
    
    func createBindings() {
        //This feature is not yet supported
    }
}

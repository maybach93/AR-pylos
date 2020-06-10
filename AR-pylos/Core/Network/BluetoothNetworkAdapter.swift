//
//  BluetoothNetworkAdapter.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//


//Low level interface to find and handle connection
import Foundation

class BluetoothNetworkAdapter: CommunicatorAdapter {
    
    private let disposeBag = DisposeBag()

    var outMessages: PublishRelay<Data> = PublishRelay<Data>() //Messages to send to others
    var inMessages: PublishSubject<Data> = PublishSubject<Data>() //Messages received from others
    
    func findMatch() -> Observable<Bool> {
        //DO NOT CHANGE BLUETOOTH YET
        return Observable.create { (observer) -> Disposable in
            observer.onNext(true)
            return Disposables.create {}
        }
    }
}

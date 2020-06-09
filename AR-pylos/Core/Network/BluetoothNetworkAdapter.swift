//
//  BluetoothNetworkAdapter.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//


//Low level interface to find and handle connection
import Foundation

protocol CommunicatorAdapter {
    var outMessages: PublishRelay<Data> { get } //Messages to send to others
    var inMessages: PublishSubject<Data> { get } //Messages received from others
    
    func findMatch() -> Observable<Bool>
}

class BluetoothNetworkAdapter: CommunicatorAdapter {
    
    private let disposeBag = DisposeBag()

    var outMessages: PublishRelay<Data> = PublishRelay<Data>() //Messages to send to others
    var inMessages: PublishSubject<Data> = PublishSubject<Data>() //Messages received from others
    
    func findMatch() -> Observable<Bool> {
        return Observable.just(true)
    }
}

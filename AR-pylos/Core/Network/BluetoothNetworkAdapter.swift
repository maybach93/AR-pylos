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
    func findMatch(asHost: Bool)
}

class BluetoothNetworkAdapter: CommunicatorAdapter {
    func findMatch(asHost: Bool) {
        
    }
}

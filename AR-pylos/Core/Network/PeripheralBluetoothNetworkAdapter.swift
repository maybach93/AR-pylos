//
//  PeripheralBluetoothNetworkAdapter.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/13/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation
import CoreBluetooth

import BluetoothKit

extension PeripheralBluetoothNetworkAdapter {
    struct Constants {
        static let dataServiceUUID = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
        static let characteristicUUID = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B24")!
    }
}
class PeripheralBluetoothNetworkAdapter: CommunicatorAdapter {
    
    private let disposeBag = DisposeBag()
    
    var outMessages: PublishRelay<Data> = PublishRelay<Data>() //Messages to send to others
    var inMessages: PublishSubject<Data> = PublishSubject<Data>() //Messages received from others
    
    private var didConnectedToCentral = PublishSubject<Void>()
    private let peripheral = BKPeripheral()
    
    init() {
        startPeripheral()
    }
    
    deinit {
        _ = try? peripheral.stop()
    }
    
    private func startPeripheral() {
        do {
            peripheral.delegate = self
            peripheral.addAvailabilityObserver(self)
            let localName = Bundle.main.infoDictionary!["CFBundleName"] as? String
            let configuration = BKPeripheralConfiguration(dataServiceUUID: Constants.dataServiceUUID, dataServiceCharacteristicUUID: Constants.characteristicUUID, localName: localName)
            try peripheral.startWithConfiguration(configuration)
        } catch let error {
            print("Error starting: \(error)")
        }
    }
     
    func findMatch() -> Single<Void> {
        return self.didConnectedToCentral.map({ $0 }).asSingle()
    }
}

extension PeripheralBluetoothNetworkAdapter: BKAvailabilityObserver {
    
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, unavailabilityCauseDidChange unavailabilityCause: BKUnavailabilityCause) {
        
    }
    
    internal func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, availabilityDidChange availability: BKAvailability) {

    }
}

extension PeripheralBluetoothNetworkAdapter: BKRemotePeerDelegate {
    func remotePeer(_ remotePeer: BKRemotePeer, didSendArbitraryData data: Data) {
        self.inMessages.onNext(data)
    }
}

extension PeripheralBluetoothNetworkAdapter: BKPeripheralDelegate {
    
    internal func peripheral(_ peripheral: BKPeripheral, remoteCentralDidConnect remoteCentral: BKRemoteCentral) {
        remoteCentral.delegate = self
        didConnectedToCentral.onNext(())
    }
    
    internal func peripheral(_ peripheral: BKPeripheral, remoteCentralDidDisconnect remoteCentral: BKRemoteCentral) {

    }
}



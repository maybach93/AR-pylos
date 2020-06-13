//
//  BluetoothNetworkAdapter.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/6/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//


//Low level interface to find and handle connection
import Foundation
import CoreBluetooth

import BluetoothKit

extension CentralBluetoothNetworkAdapter {
    struct Constants {
        static let dataServiceUUID = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B23")!
        static let characteristicUUID = UUID(uuidString: "6E6B5C64-FAF7-40AE-9C21-D4933AF45B24")!
    }
}
class CentralBluetoothNetworkAdapter: CommunicatorAdapter {
    
    private let disposeBag = DisposeBag()
    
    var outMessages: PublishRelay<Data> = PublishRelay<Data>() //Messages to send to others
    var inMessages: PublishSubject<Data> = PublishSubject<Data>() //Messages received from others
    
    private var didBecomeAvailable = PublishSubject<Void>()
    private var remotePeripheral: BKRemotePeripheral? {
        didSet {
            guard let sRemotePeripheral = remotePeripheral else { return }
            sRemotePeripheral.delegate = self
            sRemotePeripheral.peripheralDelegate = self
        }
    }
    fileprivate let central = BKCentral()
    
    init() {
        startCentral()
    }
    deinit {
        print("")
    }
    
    fileprivate func startCentral() {
        do {
            central.delegate = self
            central.addAvailabilityObserver(self)
            let configuration = BKConfiguration(dataServiceUUID: Constants.dataServiceUUID, dataServiceCharacteristicUUID: Constants.characteristicUUID)
            try central.startWithConfiguration(configuration)
        } catch let error {
            print("Error while starting: \(error)")
        }
    }
    
    func findMatch() -> Single<Bool> {
        let single = Single<Bool>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create {} }
            self.central.scanContinuouslyWithChangeHandler({ [weak self] changes, discoveries in
                guard let self = self else { return }
                if let discovery = discoveries.first {
                    self.central.connect(remotePeripheral: discovery.remotePeripheral) { remotePeripheral, error in
                        guard error == nil else {
                            print("Error connecting peripheral: \(String(describing: error))")
                            return
                        }
                        self.remotePeripheral = remotePeripheral
                        self.central.interruptScan()
                        observer(.success(true))
                    }
                }
            }, stateHandler: { newState in
                if newState == .scanning {
                    return
                } else if newState == .stopped {
                }
            }, errorHandler: { error in
            })
            return Disposables.create { }
        }
        return self.didBecomeAvailable.flatMap { (_) -> Single<Bool> in
            return single
        }.asSingle()
    }
}

extension CentralBluetoothNetworkAdapter: BKAvailabilityObserver {
    
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, unavailabilityCauseDidChange unavailabilityCause: BKUnavailabilityCause) {
        
    }
    
    internal func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, availabilityDidChange availability: BKAvailability) {
        //availabilityView.availabilityObserver(availabilityObservable, availabilityDidChange: availability)
        if availability == .available {
            didBecomeAvailable.onNext(())
        } else {
            central.interruptScan()
        }
    }
}

extension CentralBluetoothNetworkAdapter: BKCentralDelegate, BKRemotePeripheralDelegate, BKRemotePeerDelegate {
    
    // MARK: BKRemotePeripheralDelegate
    
    internal func remotePeripheral(_ remotePeripheral: BKRemotePeripheral, didUpdateName name: String) {
    }
    
    internal func remotePeer(_ remotePeer: BKRemotePeer, didSendArbitraryData data: Data) {
        //self.delegate?.didReceiveData(data: data)
    }
    
    internal func remotePeripheralIsReady(_ remotePeripheral: BKRemotePeripheral) {
    }
    
    func central(_ central: BKCentral, remotePeripheralDidDisconnect remotePeripheral: BKRemotePeripheral) {
    }
    
}

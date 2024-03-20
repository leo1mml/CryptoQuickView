//
//  ConnectivityWatcher.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 20/03/2024.
//

import Combine
import Network

protocol ConnectivityWatcher {
    var connectivityStatus: PassthroughSubject<Bool, Never> { get }
    func start()
    func stop()
}

class ConnectivityWatcherImpl: ConnectivityWatcher {
    private var monitor: NWPathMonitor
    private var cancellables = Set<AnyCancellable>()
    
    // Publisher to emit connectivity status changes
    let connectivityStatus = PassthroughSubject<Bool, Never>()
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            // Emit true if network is available, false otherwise
            let isConnected = path.status == .satisfied
            self?.connectivityStatus.send(isConnected)
        }
    }
    
    // Start monitoring connectivity status
    func start() {
        let queue = DispatchQueue(label: "ConnectivityWatcher")
        monitor.start(queue: queue)
    }
    
    // Stop monitoring connectivity status
    func stop() {
        monitor.cancel()
    }
}

@testable
import CryptoQuickView
import XCTest
import Combine

class ConnectivityWatcherTests: XCTestCase {
    var watcher: ConnectivityWatcher!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        watcher = ConnectivityWatcherImpl()
    }
    
    override func tearDown() {
        watcher.stop() // Stop monitoring to clean up
        watcher = nil
        cancellables = []
        super.tearDown()
    }
    
    func testConnectivityStatusUpdates() {
        let expectation = self.expectation(description: "Connectivity status updates")
        
        // Subscribe to connectivity status changes
        var receivedStatus: Bool?
        let cancellable = watcher.connectivityStatus
            .sink { isConnected in
                receivedStatus = isConnected
                expectation.fulfill()
            }
        
        // Start monitoring connectivity
        watcher.start()
        
        // Wait for expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Expectation failed: \(error?.localizedDescription ?? "")")
        }
        
        // Verify received connectivity status
        XCTAssertNotNil(receivedStatus, "Received connectivity status should not be nil")
        
        // Cancel the sink
        cancellable.cancel()
    }
}

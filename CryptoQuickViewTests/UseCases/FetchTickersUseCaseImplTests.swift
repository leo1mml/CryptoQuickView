@testable
import CryptoQuickView
import XCTest
import Combine

class FetchTickersUseCaseImplTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    func testFetch_Success_ProperlyShowsResult() {
        let expectation = expectation(description: "expected values")
        
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        
        let networkMock = MockNetwork()
        networkMock.error = nil
        networkMock.responses = [url: [["BTC", 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]]]
        
        let sut = FetchTickersUseCaseImpl(
            request: request,
            network: networkMock
        )
        
        sut.fetch()
            .sink { completion in
                if case .failure = completion {
                    XCTFail("No failure expected")
                }
            } receiveValue: { symbolMappings in
                XCTAssertEqual(symbolMappings.count, 1)
                XCTAssertEqual(symbolMappings[0].symbol, "BTC")
                XCTAssertEqual(symbolMappings[0].dailyChangePercentage, 2)
                XCTAssertEqual(symbolMappings[0].lastPrice, 2)
                XCTAssertEqual(symbolMappings[0].ask, 2)
                XCTAssertEqual(symbolMappings[0].bid, 2)
                XCTAssertEqual(symbolMappings[0].bidSize, 2)
                XCTAssertEqual(symbolMappings[0].dailyChange, 2)
                XCTAssertEqual(symbolMappings[0].high, 2)
                XCTAssertEqual(symbolMappings[0].low, 2)
                XCTAssertEqual(symbolMappings[0].volume, 2)

                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetch_Error_ProperlyShowsResult() {
        let expectation = expectation(description: "expected error")
        
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        
        let networkMock = MockNetwork()
        networkMock.error = .other(error: URLError(.badURL))
        networkMock.responses = [:]
        
        let sut = FetchTickersUseCaseImpl(
            request: request,
            network: networkMock
        )
        
        sut.fetch()
            .sink { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            } receiveValue: { symbolMappings in
                XCTFail("No failure expected")
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
}

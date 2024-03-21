@testable
import CryptoQuickView
import XCTest
import Combine

class FetchCurrencyLabelsUseCaseTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    func testFetch_Success_ProperlyShowsResult() {
        let expectation = expectation(description: "expected values")
        
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        
        let networkMock = MockNetwork()
        networkMock.error = nil
        networkMock.responses = [url: [[["BTC", "Bitcoin"]]]]
        
        let sut = FetchCurrencyLabelUseCaseImpl(
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
                XCTAssertEqual(symbolMappings[0].fullName, "Bitcoin")
                
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
        
        let sut = FetchCurrencyLabelUseCaseImpl(
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

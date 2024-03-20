import XCTest
import Combine
@testable
import CryptoQuickView

class CryptoListViewModelImplTests: XCTestCase {
    
    var sut: CryptoListViewModelImpl!
    var fetchTickersUseCase: MockFetchTickersUseCase!
    var fetchLabelsUseCase: MockFetchCurrencyLabelsUseCase!
    var formatTradeUseCase: MockFormatTradeDataUseCase!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        fetchTickersUseCase = MockFetchTickersUseCase()
        fetchLabelsUseCase = MockFetchCurrencyLabelsUseCase()
        formatTradeUseCase = MockFormatTradeDataUseCase()
        sut = CryptoListViewModelImpl(fetchTickersUseCase: fetchTickersUseCase,
                                      fetchLabelsUseCase: fetchLabelsUseCase,
                                      formatTradeUseCase: formatTradeUseCase,
                                      connectivityWatcher: ConnectivityWatcherImpl(),
                                      updateInterval: 3)
    }
    
    override func tearDown() {
        fetchTickersUseCase = nil
        fetchLabelsUseCase = nil
        formatTradeUseCase = nil
        sut = nil
        super.tearDown()
    }
    
    func testStartIntegration_ProperlyCallsUseCases() {
        let expectation = expectation(description: "Called UseCases")
        sut.$shownItems
            .dropFirst(2)
            .sink { _ in
                if (
                    self.fetchLabelsUseCase.calledFetch &&
                    self.fetchTickersUseCase.calledFetch &&
                    self.formatTradeUseCase.calledFormat
                ) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        sut.startIntegration()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSetupSearch_WithSearchText_ProperlyFiltersItems() {
        let expectation = expectation(description: "fetched items")
        var isFiltering = false
        sut.$shownItems
            .dropFirst(2)
            .sink { items in
                if (isFiltering) {
                    XCTAssert(items.isEmpty)
                    return
                }
                XCTAssert(!items.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.startIntegration()
        wait(for: [expectation], timeout: 1)
        isFiltering = true
        sut.searchText = "sol"
    }
    
    func testStartIntegration_ProperlyCallsTimerFetch() {
        let expectation = expectation(description: "Called UseCases")
        sut.$shownItems
            .dropFirst(2)
            .sink { _ in
                if (self.fetchTickersUseCase.numberOfCalls == 2) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        sut.startIntegration()
        
        wait(for: [expectation], timeout: 4)
    }
    
    func testStartIntegration_WithFailingLabels_ProperlyShowErrorMessage() {
        let expectation = expectation(description: "received error")
        fetchLabelsUseCase.error = URLError(URLError.badURL)
        sut.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                expectation.fulfill()
                XCTAssert(!errorMessage.isEmpty)
            }
            .store(in: &cancellables)
        sut.startIntegration()
        wait(for: [expectation], timeout: 1)
    }
    
    func testStartIntegration_WithFailingTickers_ProperlyShowErrorMessage() {
        let expectation = expectation(description: "received error")
        fetchTickersUseCase.error = URLError(URLError.badURL)
        sut.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                expectation.fulfill()
                XCTAssert(!errorMessage.isEmpty)
            }
            .store(in: &cancellables)
        sut.startIntegration()
        wait(for: [expectation], timeout: 1)
    }
}

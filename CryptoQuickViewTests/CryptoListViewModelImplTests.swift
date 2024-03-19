import XCTest
import Combine
@testable
import CryptoQuickView

class MockFetchTickersUseCase: FetchTickersUseCase {
    
    private(set) var calledFetch = false
    private(set) var numberOfCalls = 0
    var error: Error?
    
    func fetch() -> AnyPublisher<[TradeData], Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        calledFetch = true
        numberOfCalls += 1
        let tradeData = TradeData(
            symbol: "tBTCUSD",
            bid: 0,
            bidSize: 0,
            ask: 0,
            askSize: 0,
            dailyChange: 0.3,
            dailyChangePercentage: 0.05,
            lastPrice: 50_000.0,
            volume: 222,
            high: 55555,
            low: 11
        )

        return Just([tradeData])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockFetchCurrencyLabelsUseCase: FetchCurrencyLabelsUseCase {
    
    private(set) var calledFetch = false
    var error: Error?
    
    func fetch() -> AnyPublisher<[SymbolMapping], Error> {
        calledFetch = true
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let mapping = SymbolMapping(symbol: "BTC", fullName: "Bitcoin")
        return Just([mapping])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockFormatTradeDataUseCase: FormatTradeDataUseCase {
    
    private(set) var calledFormat = false
    
    func format(_ tradeData: TradeData, using mappings: [SymbolMapping]) -> CryptoListItemViewModel {
        calledFormat = true
        return CryptoListItemViewModel(
            title: "Bitcoin",
            subtitle: "BTC",
            detailImage: "",
            text1: "$ 50000.00",
            text2: "5.00%"
        )
    }
}

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

        XCTAssert(fetchTickersUseCase.numberOfCalls == 2)
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

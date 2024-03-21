import XCTest
@testable
import CryptoQuickView

class FormatTradeDataUseCaseImplTests: XCTestCase {
    
    private var sut: FormatTradeDataUseCaseImpl!
    private var tradeData: TradeData!
    private var mappings: [SymbolMapping]!
    
    override func setUp() {
        sut = FormatTradeDataUseCaseImpl()
        tradeData = TradeData(
            symbol: "tBTC:USD",
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
        mappings = [SymbolMapping(symbol: "BTC", fullName: "Bitcoin")]

    }

    func testFormatTradeData_WithValidData_ReturnsCorrectViewModel() {
        // When
        let viewModel = sut.format(tradeData, using: mappings)

        // Then
        XCTAssertEqual(viewModel.title, "Bitcoin")
        XCTAssertEqual(viewModel.subtitle, "BTC")
        XCTAssertEqual(viewModel.text1, "US$ 50000.00")
        XCTAssertEqual(viewModel.text2, "5.00%")
    }

    func testFormatTradeData_WithMissingMappings_ReturnsDefaultTitle() {
        // Given
        let mappings: [SymbolMapping] = []

        // When
        let viewModel = sut.format(tradeData, using: mappings)

        // Then
        XCTAssertEqual(viewModel.title, "BTC")
    }
    
    func testFormatTradeData_WithSymbolWithoutColon_ReturnsViewModelWithDefaultSubtitle() {
        // Given
        tradeData = TradeData(
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
        // When
        let viewModel = sut.format(tradeData, using: mappings)

        // Then
        XCTAssertEqual(viewModel.subtitle, "BTC")
    }
}

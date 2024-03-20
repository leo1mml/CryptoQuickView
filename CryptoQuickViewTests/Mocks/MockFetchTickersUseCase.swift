//
//  MockFetchTickersUseCase.swift
//  CryptoQuickViewTests
//
//  Created by Leonel Lima on 20/03/2024.
//

@testable
import CryptoQuickView
import Foundation
import Combine

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

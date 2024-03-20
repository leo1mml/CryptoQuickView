//
//  MockFetchCurrencyLabelsUseCase.swift
//  CryptoQuickViewTests
//
//  Created by Leonel Lima on 20/03/2024.
//

@testable
import CryptoQuickView
import Foundation
import Combine

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

//
//  MockTradeDataUseCase.swift
//  CryptoQuickViewTests
//
//  Created by Leonel Lima on 20/03/2024.
//

@testable
import CryptoQuickView
import Foundation
import Combine

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

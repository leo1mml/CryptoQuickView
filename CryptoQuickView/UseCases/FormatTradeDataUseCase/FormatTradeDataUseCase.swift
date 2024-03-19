//
//  FormatDataUseCase.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 19/03/2024.
//

import Foundation

protocol FormatTradeDataUseCase {
    func format(_ tradeData: TradeData, using mappings: [SymbolMapping]) -> CryptoListItemViewModel
}

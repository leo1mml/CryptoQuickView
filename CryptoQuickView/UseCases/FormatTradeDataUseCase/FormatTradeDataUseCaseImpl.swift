//
//  FormatTradeDataUseCaseImpl.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 19/03/2024.
//

import Foundation

class FormatTradeDataUseCaseImpl: FormatTradeDataUseCase {
    func format(_ tradeData: TradeData, using mappings: [SymbolMapping]) -> CryptoListItemViewModel {
        let (lhs, rhs) = getTradingPairs(from: tradeData.symbol)
        let title = mappings.first { mapping in
            mapping.symbol == lhs
        }?.fullName
        let currencySymbol = getFiatSymbol(forCurrencyCode: rhs) ?? ""
        return CryptoListItemViewModel(
            title: title ?? lhs,
            subtitle: lhs,
            detailImage: "",
            text1: "\(String(format: "\(currencySymbol) %.2f", tradeData.lastPrice))",
            text2: "\((String(format: "%.2f", tradeData.dailyChangePercentage * 100)))"
        )
    }
    
    private func getFiatSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    private func getTradingPairs(from symbol: String) -> (String, String) {
        var symbol = symbol
        symbol.removeFirst()
        let slices: [String.SubSequence]
        if symbol.contains(":") {
            slices = symbol.split(separator: ":")
        } else {
            let midpoint = symbol.index(symbol.startIndex, offsetBy: symbol.count / 2)
            let firstHalf = symbol[..<midpoint]
            let secondHalf = symbol[midpoint...]
            slices = [firstHalf, secondHalf]
        }
        guard slices.count == 2 else { return ("","") }
        return (String(slices[0]), String(slices[1]))
    }
}

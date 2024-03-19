//
//  BitFinexRequestFactory.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 18/03/2024.
//

import Foundation

class BitfinexRequestFactory: RequestFactory {
    func createTickersRequest(symbols: String) -> URLRequest {
        let queryItem = URLQueryItem(name: "symbols", value: symbols)
        let url = BitfinexAPI.getURL(for: .tickers, queryItems: [queryItem])
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    func createLabelsRequest() -> URLRequest {
        let url = BitfinexAPI.getURL(for: .labels)
        return URLRequest(url: url)
    }
}

//
//  FetchCurrencyLabelUseCaseImpl.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 19/03/2024.
//

import Foundation
import Combine

class FetchCurrencyLabelUseCaseImpl: FetchCurrencyLabelsUseCase {
    
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func fetch() -> AnyPublisher<[SymbolMapping], Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[[String]]]
                    if let jsonArray = jsonArray {
                        var symbolMappings: [SymbolMapping] = []
                        for array in jsonArray[0] {
                            if array.count == 2 {
                                let symbol = array[0]
                                let fullName = array[1]
                                let mapping = SymbolMapping(symbol: symbol, fullName: fullName)
                                symbolMappings.append(mapping)
                            }
                        }
                        return symbolMappings
                    }
                    throw URLError(URLError.badServerResponse)
                } catch {
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
}

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
    private let network: NetworkProtocol

    init(request: URLRequest, network: NetworkProtocol) {
        self.network = network
        self.request = request
    }
    
    func fetch() -> AnyPublisher<[SymbolMapping], Error> {
        return network.fetch(request: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap({ data in
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
                    throw NetworkError.other(error: URLError(.cannotDecodeContentData))
                } catch {
                    throw error
                }
            })
            .eraseToAnyPublisher()
    }
}

//
//  FetchCurrencyLabelsUseCase.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 19/03/2024.
//

import Foundation
import Combine

protocol FetchCurrencyLabelsUseCase {
    func fetch() -> AnyPublisher<[SymbolMapping], Error>
}

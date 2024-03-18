//
//  CryptoQuickViewApp.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 18/03/2024.
//

import SwiftUI

@main
struct CryptoQuickViewApp: App {
    
    var body: some Scene {
        WindowGroup {
            listView
        }
    }
    
    @MainActor
    var listView: some View {
        let fetchTickersRequest = BitfinexRequestFactory().createTickersRequest(symbols: "ALL")
        let fetchTickersUseCase = FetchTickersUseCaseImpl(request: fetchTickersRequest)
        let viewModel = CryptoListViewModelImpl(fetchTickersUseCase: fetchTickersUseCase)
        let view = CryptoListView(viewModel: viewModel)
        return view
    }
}

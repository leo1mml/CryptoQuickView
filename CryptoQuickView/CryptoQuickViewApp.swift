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
    
    private var listView: some View {
        let fetchTickersRequest = BitfinexRequestFactory().createTickersRequest(symbols: "tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,t EOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tLUNA:USD,tMATIC:USD,tNEXO :USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD")
        let fetchTickersUseCase = FetchTickersUseCaseImpl(request: fetchTickersRequest)
        let viewModel = CryptoListViewModelImpl(fetchTickersUseCase: fetchTickersUseCase)
        let view = CryptoListView(viewModel: viewModel)
        return view
    }
}

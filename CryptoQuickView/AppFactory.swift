//
//  AppFactory.swift
//  CryptoQuickView
//
//  Created by Leonel Lima on 19/03/2024.
//

import SwiftUI

class AppFactory {
    static var listView: some View {
        let symbols = "tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,t EOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tLUNA:USD,tMATIC:USD,tNEXO :USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD"
        let fetchTickersRequest = BitfinexRequestFactory()
            .createTickersRequest(symbols: symbols)
        let fetchTickersUseCase = FetchTickersUseCaseImpl(request: fetchTickersRequest)
        let formatTradeUseCase = FormatTradeDataUseCaseImpl()
        let viewModel = CryptoListViewModelImpl(fetchTickersUseCase: fetchTickersUseCase, formatTradeUseCase: formatTradeUseCase)
        let view = CryptoListView(viewModel: viewModel)
        return view
    }
}

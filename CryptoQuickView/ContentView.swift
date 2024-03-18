import SwiftUI

struct ContentView: View {
    var body: some View {
        CryptoListView(viewModel: CryptoListViewModelImpl(fetchTickersUseCase: FetchTickersUseCaseImpl()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListView(viewModel: CryptoListViewModelImpl(fetchTickersUseCase: FetchTickersUseCaseImpl()))
    }
}


#Preview {
    ContentView()
}

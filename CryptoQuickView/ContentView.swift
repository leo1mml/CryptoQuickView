import SwiftUI

struct ContentView: View {
    var body: some View {
        CryptoList(viewModel: CryptoListViewModelImpl())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoList(viewModel: CryptoListViewModelImpl())
    }
}


#Preview {
    ContentView()
}

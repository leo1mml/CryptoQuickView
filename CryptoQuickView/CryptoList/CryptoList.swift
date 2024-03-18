import SwiftUI

struct CryptoList<ViewModel>: View where ViewModel: CryptoListViewModel {
    
    @ObservedObject
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.shownItems, id: \.id) { item in
                            CryptoListItemView(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}


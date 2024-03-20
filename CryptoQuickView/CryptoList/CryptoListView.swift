import SwiftUI

struct CryptoListView<ViewModel>: View where ViewModel: CryptoListViewModel {
    
    @ObservedObject
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate func errorMessage() -> some View {
        return HStack {
            Spacer()
            Text(viewModel.errorMessage)
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                }
                VStack {
                    ScrollView {
                        if !viewModel.errorMessage.isEmpty {
                            errorMessage()
                        }
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
            .autocorrectionDisabled()
            .task {
                viewModel.startIntegration()
            }
        }
    }
}

struct CryptoListView_Previews: PreviewProvider {
    static var previews: some View {
        return AppFactory.listView
    }
}



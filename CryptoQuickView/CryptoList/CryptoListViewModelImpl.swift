import SwiftUI
import Combine

class CryptoListViewModelImpl: CryptoListViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var allItems: [CryptoListItemViewModel] = [
        CryptoListItemViewModel(title: "Item 1", subtitle: "Subtitle 1", detailImage: "image1", text1: "Text 1", text2: "Text 2"),
        CryptoListItemViewModel(title: "Item 2", subtitle: "Subtitle 2", detailImage: "image2", text1: "Text 3", text2: "Text 4"),
    ]
    @Published
    var shownItems: [CryptoListItemViewModel] = []
    @Published
    var searchText: String = ""
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterItems(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterItems(searchText: String) {
        if searchText.isEmpty {
            shownItems = allItems
        } else {
            shownItems = allItems.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func startIntegration() {
    }
}

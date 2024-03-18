import SwiftUI
import Combine

class CryptoListViewModelImpl: CryptoListViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var allItems: [CryptoListItemViewModel] = []
    @Published
    var shownItems: [CryptoListItemViewModel] = []
    @Published
    var searchText: String = ""
    let fetchTickersUseCase: FetchTickersUseCase
    
    init(fetchTickersUseCase: FetchTickersUseCase) {
        self.fetchTickersUseCase = fetchTickersUseCase
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterItems(searchText: searchText)
            }
            .store(in: &cancellables)
        
        fetchTickersUseCase.fetch()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.showError(error)
                }
            } receiveValue: { [weak self] values in
                self?.allItems = values.map { tradeData in
                    return CryptoListItemViewModel(
                        title: tradeData.symbol,
                        subtitle: tradeData.symbol,
                        detailImage: "",
                        text1: "\(String(format: "%.3f", tradeData.lastPrice))",
                        text2: "\((String(format: "%.2f", tradeData.dailyChangePercentage * 100)))"
                    )
                }
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
    
    private func showError(_ error: Error) {}
    
    func startIntegration() {
    }
}

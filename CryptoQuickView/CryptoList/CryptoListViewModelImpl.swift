import SwiftUI
import Combine

class CryptoListViewModelImpl: CryptoListViewModel {
    @Published
    var isLoading: Bool = true
    @Published
    var errorMessage: String = ""
    @Published
    var shownItems: [CryptoListItemViewModel] = []
    @Published
    var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var allItems: [CryptoListItemViewModel] = []
    private let fetchTickersUseCase: FetchTickersUseCase
    private static let updateInterval: TimeInterval = 5
    private let timerPublisher = Timer
        .publish(every: updateInterval, on: .main, in: .default)
        .autoconnect()
    
    init(fetchTickersUseCase: FetchTickersUseCase) {
        self.fetchTickersUseCase = fetchTickersUseCase
    }
    
    func startIntegration() {
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterItems(searchText: searchText)
            }
            .store(in: &cancellables)
        timerPublisher
            .flatMap { _ in
                self.fetchTickersUseCase.fetch()
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.showError()
                    }
                },
                receiveValue: { [weak self] values in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.errorMessage = ""
                    let items = values.map { tradeData in
                        return CryptoListItemViewModel(
                            title: tradeData.symbol,
                            subtitle: tradeData.symbol,
                            detailImage: "",
                            text1: "\(String(format: "%.2f", tradeData.lastPrice))",
                            text2: "\((String(format: "%.2f", tradeData.dailyChangePercentage * 100)))"
                        )
                    }
                    self.allItems = items
                    self.filterItems(searchText: self.searchText)
                }
            )
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
    
    private func showError() {
        errorMessage = "Something went wrong, lets try to connect again in a few seconds"
    }
}

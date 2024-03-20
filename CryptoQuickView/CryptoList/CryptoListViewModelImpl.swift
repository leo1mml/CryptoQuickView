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
    private let fetchLabelsUseCase: FetchCurrencyLabelsUseCase
    private let formatTradeUseCase: FormatTradeDataUseCase
    private let timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>
    private let connectivityWatcher: ConnectivityWatcher
    
    enum CryptoListErrors: Error {
        case NoNetwork
        case FailedGettingLabels
        case FailedGettingTickers
    }

    init(
        fetchTickersUseCase: FetchTickersUseCase,
        fetchLabelsUseCase: FetchCurrencyLabelsUseCase,
        formatTradeUseCase: FormatTradeDataUseCase,
        connectivityWatcher: ConnectivityWatcher,
        updateInterval: TimeInterval = 5
    ) {
        self.fetchLabelsUseCase = fetchLabelsUseCase
        self.formatTradeUseCase = formatTradeUseCase
        self.fetchTickersUseCase = fetchTickersUseCase
        self.connectivityWatcher = connectivityWatcher
        self.timerPublisher = Timer
            .publish(every: updateInterval, on: .main, in: .default)
            .autoconnect()
    }
    
    func startIntegration() {
        setupConnectivityWatcher()
        setupSearch()
        setupDataFetch()
    }
}

private extension CryptoListViewModelImpl {
    
    func setupConnectivityWatcher() {
        connectivityWatcher.connectivityStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                if !isConnected {
                    self?.show(error: .NoNetwork)
                }
            }
            .store(in: &cancellables)

        // Start monitoring connectivity
        connectivityWatcher.start()
    }
    
    func setupSearch() {
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterItems(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    func filterItems(searchText: String) {
        if searchText.isEmpty {
            shownItems = allItems
        } else {
            shownItems = allItems.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func setupDataFetch() {
        fetchLabelsUseCase
            .fetch()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.show(error: .FailedGettingLabels)
                    break
                }
            } receiveValue: { [weak self] mappings in
                guard let self = self else { return }
                self.sink(fetchTickersUseCase.fetch(), with: mappings)
                self.setupTimerPolling(using: mappings)
            }
            .store(in: &cancellables)
        
    }
    
    func setupTimerPolling(using mappings: [SymbolMapping]) {
        let pub = timerPublisher
            .flatMap { _ in
                self.fetchTickersUseCase.fetch()
            }
            .eraseToAnyPublisher()
        sink(pub, with: mappings)
    }
    
    func sink(_ pub: AnyPublisher<[TradeData], Error>, with mappings: [SymbolMapping]) {
        pub
            .receive(on: RunLoop.main)
            .sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.show(error: .FailedGettingTickers)
                    self?.setupTimerPolling(using: mappings)
                }
            },
            receiveValue: { [weak self] values in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = ""
                let items = values.map {
                    self.formatTradeUseCase.format($0, using: mappings)
                }
                self.allItems = items
                self.filterItems(searchText: self.searchText)
            }
        )
        .store(in: &cancellables)
    }
    
    func show(error: CryptoListErrors) {
        switch error {
        case .NoNetwork:
            errorMessage = "It seems you have no connection with the internet."
        case .FailedGettingLabels:
            errorMessage = "We were not able to get the initial data. Please try again later."
        case .FailedGettingTickers:
            errorMessage = "Something went wrong, lets try again in a few seconds"
        }
    }
}

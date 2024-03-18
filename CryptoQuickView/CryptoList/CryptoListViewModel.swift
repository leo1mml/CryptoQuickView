import Combine

@MainActor
protocol CryptoListViewModel: ObservableObject {
    var searchText: String { get set }
    var shownItems: [CryptoListItemViewModel] { get }
    func startIntegration()
}

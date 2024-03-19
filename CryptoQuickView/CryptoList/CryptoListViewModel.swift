import Combine

protocol CryptoListViewModel: ObservableObject {
    var isLoading: Bool { get }
    var errorMessage: String { get }
    var searchText: String { get set }
    var shownItems: [CryptoListItemViewModel] { get }
    func startIntegration()
}

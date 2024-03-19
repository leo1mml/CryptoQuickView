import Foundation

protocol RequestFactory {
    func createTickersRequest(symbols: String) -> URLRequest
    func createLabelsRequest() -> URLRequest
}

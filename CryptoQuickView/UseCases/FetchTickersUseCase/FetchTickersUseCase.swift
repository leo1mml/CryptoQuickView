import Foundation
import Combine

protocol FetchTickersUseCase {
    func fetch(tickersRequest: URLRequest) -> AnyPublisher<TickerValues, Error>
}

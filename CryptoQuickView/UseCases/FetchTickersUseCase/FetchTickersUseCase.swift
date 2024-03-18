import Foundation
import Combine

protocol FetchTickersUseCase {
    func fetch() -> AnyPublisher<[TradeData], Error>
}

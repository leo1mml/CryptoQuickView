import Foundation
import Combine

protocol NetworkProtocol {
    func fetch<T>(
        request: URLRequest,
        decodableType: T.Type
    ) -> AnyPublisher<T, NetworkError> where T: Decodable

    func fetch(
        request: URLRequest
    ) -> AnyPublisher<Data, NetworkError>
}

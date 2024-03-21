@testable 
import CryptoQuickView
import XCTest
import Combine

final class MockNetwork: NetworkProtocol {
    var error: NetworkError?
    var responses: [URL: Any] = [:]

    func fetch<T>(
        request: URLRequest,
        decodableType: T.Type
    ) -> AnyPublisher<T, NetworkError> where T : Decodable {
        if let error {
            return Fail(
                error: error
            )
            .eraseToAnyPublisher()
        }

        guard let url = request.url, let response = responses[url] as? T else {
            return Fail(
                error: NetworkError.requestFailed(
                    urlError: .badServerResponse
                )
            )
            .eraseToAnyPublisher()
        }

        return Just(
            response
        )
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
    
    func fetch(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        if let error {
            return Fail(
                error: error
            )
            .eraseToAnyPublisher()
        }

        guard let url = request.url, let response = responses[url] else {
            return Fail(
                error: NetworkError.requestFailed(
                    urlError: .badServerResponse
                )
            )
            .eraseToAnyPublisher()
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: response, options: [])

            return Just(
                data
            )
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        } catch {
            return Fail(
                error: NetworkError.other(error: error)
            )
            .eraseToAnyPublisher()
        }
    }
}

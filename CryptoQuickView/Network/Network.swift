import Foundation
import Combine

final class Network: NetworkProtocol {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetch<T>(
        request: URLRequest,
        decodableType: T.Type
    ) -> AnyPublisher<T, NetworkError> where T: Decodable {
        return session
            .dataTaskPublisher(for: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed(urlError: .badServerResponse)
                }

                guard httpResponse.statusCode == 200 else {
                    throw NetworkError.badReponseStatusCode(code: httpResponse.statusCode, responseData: data)
                }

                return try JSONDecoder().decode(T.self, from: data)
            }
            .mapNetworkError()
    }

    func fetch(
        request: URLRequest
    ) -> AnyPublisher<Data, NetworkError> {
        return session
            .dataTaskPublisher(for: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed(urlError: .badServerResponse)
                }

                guard httpResponse.statusCode == 200 else {
                    throw NetworkError.badReponseStatusCode(code: httpResponse.statusCode, responseData: data)
                }

                return data
            }
            .mapNetworkError()
    }
}

private extension Publisher {
    func mapNetworkError() -> AnyPublisher<Output, NetworkError> {
        return self.mapError { error in
            switch error {
            case let error as DecodingError:
                return .decodingFailed(decodingError: error)
            case let error as URLError where error.errorCode == NSURLErrorNotConnectedToInternet:
                return .notConnectedToInternet(urlError: error)
            case let error as URLError:
                return .requestFailed(urlError: error.code)
            case let error as NetworkError:
                return error
            default:
                return .other(error: error)
            }
        }
        .eraseToAnyPublisher()
    }
}

import Foundation
import Combine

class FetchTickersUseCaseImpl: FetchTickersUseCase {
    func fetch(tickersRequest: URLRequest) -> AnyPublisher<TickerValues, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: tickersRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: TickerValues.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

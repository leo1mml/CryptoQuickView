import Foundation
import Combine

class FetchTickersUseCaseImpl: FetchTickersUseCase {
    
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func fetch() -> AnyPublisher<[TradeData], Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]]
                    if let jsonArray = jsonArray {
                        var tradeDataArray: [TradeData] = []
                        for array in jsonArray {
                            if let tradeData = TradeData(dataArray: array) {
                                tradeDataArray.append(tradeData)
                            }
                        }
                        return tradeDataArray
                    }
                    throw URLError(URLError.badServerResponse)
                } catch {
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
}

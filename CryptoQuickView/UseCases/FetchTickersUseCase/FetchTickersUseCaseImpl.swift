import Foundation
import Combine

class FetchTickersUseCaseImpl: FetchTickersUseCase {
    
    private let request: URLRequest
    private let network: NetworkProtocol

    init(request: URLRequest, network: NetworkProtocol) {
        self.network = network
        self.request = request
    }

    func fetch() -> AnyPublisher<[TradeData], Error> {
        return network.fetch(request: request)
            .timeout(5, scheduler: RunLoop.main)
            .tryMap { data in
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

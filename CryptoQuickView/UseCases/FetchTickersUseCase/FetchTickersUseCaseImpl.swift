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
                            if array.count == 11, let symbol = array[0] as? String {
                                let bid = array[1] as? Double ?? 0.0
                                let bidSize = array[2] as? Double ?? 0.0
                                let ask = array[3] as? Double ?? 0.0
                                let askSize = array[4] as? Double ?? 0.0
                                let dailyChange = array[5] as? Double ?? 0.0
                                let dailyChangePercentage = array[6] as? Double ?? 0.0
                                let lastPrice = array[7] as? Double ?? 0.0
                                let volume = array[8] as? Double ?? 0.0
                                let high = array[9] as? Double ?? 0.0
                                let low = array[10] as? Double ?? 0.0
                                
                                let tradeData = TradeData(symbol: symbol,
                                                          bid: bid,
                                                          bidSize: bidSize,
                                                          ask: ask,
                                                          askSize: askSize,
                                                          dailyChange: dailyChange,
                                                          dailyChangePercentage: dailyChangePercentage,
                                                          lastPrice: lastPrice,
                                                          volume: volume,
                                                          high: high,
                                                          low: low)
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

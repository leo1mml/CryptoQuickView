import UIKit
import Foundation

// Define a struct to represent the decoded response
struct TradeData {
    let symbol: String
    let bid: Double
    let bidSize: Double
    let ask: Double
    let askSize: Double
    let dailyChange: Double
    let dailyChangePercentage: Double
    let lastPrice: Double
    let volume: Double
    let high: Double
    let low: Double
    
    init(
        symbol: String,
        bid: Double,
        bidSize: Double,
        ask: Double,
        askSize: Double,
        dailyChange: Double,
        dailyChangePercentage: Double,
        lastPrice: Double,
        volume: Double,
        high: Double,
        low: Double
    ) {
        self.symbol = symbol
        self.bid = bid
        self.bidSize = bidSize
        self.ask = ask
        self.askSize = askSize
        self.dailyChange = dailyChange
        self.dailyChangePercentage = dailyChangePercentage
        self.lastPrice = lastPrice
        self.volume = volume
        self.high = high
        self.low = low
    }
    
    init?(dataArray: [Any]) {
        if dataArray.count == 11, let symbol = dataArray[0] as? String {
            let bid = dataArray[1] as? Double ?? 0.0
            let bidSize = dataArray[2] as? Double ?? 0.0
            let ask = dataArray[3] as? Double ?? 0.0
            let askSize = dataArray[4] as? Double ?? 0.0
            let dailyChange = dataArray[5] as? Double ?? 0.0
            let dailyChangePercentage = dataArray[6] as? Double ?? 0.0
            let lastPrice = dataArray[7] as? Double ?? 0.0
            let volume = dataArray[8] as? Double ?? 0.0
            let high = dataArray[9] as? Double ?? 0.0
            let low = dataArray[10] as? Double ?? 0.0
            
            self.symbol = symbol
            self.bid = bid
            self.bidSize = bidSize
            self.ask = ask
            self.askSize = askSize
            self.dailyChange = dailyChange
            self.dailyChangePercentage = dailyChangePercentage
            self.lastPrice = lastPrice
            self.volume = volume
            self.high = high
            self.low = low
        } else {
            return nil
        }
    }
    
}

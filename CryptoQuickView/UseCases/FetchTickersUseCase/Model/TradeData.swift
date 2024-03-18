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
}

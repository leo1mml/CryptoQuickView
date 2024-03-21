import Foundation

enum BitfinexAPI {
    static let scheme = "https"
    static let host = "api-pub.bitfinex.com"
    static let version = "/v2/"
    
    enum Endpoints: String {
        case tickers
        case labels = "conf/pub:map:currency:label"
    }
    
    static func getURL(for endpoint: Endpoints, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        let endpoint = endpoint.rawValue
        let path = version + endpoint
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
    
    static func getImageURL(for symbol: String) -> URL {
        return URL(string: "https://raw.githubusercontent.com/Cryptofonts/cryptoicons/master/64/\(symbol.lowercased()).png")!
    }
}

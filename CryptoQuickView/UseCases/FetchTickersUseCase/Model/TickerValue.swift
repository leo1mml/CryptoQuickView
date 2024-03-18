import Foundation

enum TickerValueLabels: Int {
    case symbol = 0
    case bid
    case bidSize
    case ask
    case askSize
    case dailyChange
    case dailyChangeRelative
    case lastPrice
    case volume
    case high
    case low
}

enum TickerValue: Codable {
    case double(Double)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(TickerValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TickerValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

typealias TickerValues = [[TickerValue]]

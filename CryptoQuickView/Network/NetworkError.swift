import Foundation

public enum NetworkError: Error {
    case notConnectedToInternet(urlError: URLError)
    case requestFailed(urlError: URLError.Code)
    case decodingFailed(decodingError: DecodingError)
    case badReponseStatusCode(code: Int, responseData: Data)
    case other(error: Error)
}

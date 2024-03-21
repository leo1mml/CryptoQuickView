@testable 
import CryptoQuickView
import XCTest
import Combine

final class NetworkTests: XCTestCase {
    // Mock URLSession
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        try super.setUpWithError()

        let mockResponse: [String] = ["Mock", "Response"]
        let mockJSONData = try! JSONSerialization.data(
            withJSONObject: mockResponse,
            options: .prettyPrinted
        )
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(
                    string: "https://google.com"
                )!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, mockJSONData)
        }
    }

    func test_fetch_decodable_success() {
        let expectation = expectation(description: "expected values")


        let network = Network(session: urlSession)
        let request = URLRequest(
            url: URL(
                string: "https://google.com"
            )!
        )
        network.fetch(
            request: request,
            decodableType: [String].self
        )
        .sink(
            receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("No failure expected")
                }
            },
            receiveValue: { response in
                XCTAssertEqual(response.count, 2)
                XCTAssertEqual(response[0], "Mock")
                XCTAssertEqual(response[1], "Response")
                expectation.fulfill()
            }
        )
        .store(in: &subscriptions)

        wait(for: [expectation], timeout: 1)
    }

    func test_fetch_decodable_decodingFailure() {
        let expectation = expectation(description: "expected values")


        let network = Network(session: urlSession)
        let request = URLRequest(
            url: URL(
                string: "https://google.com"
            )!
        )
        network.fetch(
            request: request,
            decodableType: String.self
        )
        .sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    switch error {
                    case .decodingFailed:
                        expectation.fulfill()
                    default:
                        break
                    }
                }
            },
            receiveValue: { response in
                XCTFail("Should not receive value")
            }
        )
        .store(in: &subscriptions)

        wait(for: [expectation], timeout: 1)
    }

    func testFetch_DecodingFailed() throws {
        // Given
        let url: URL = try XCTUnwrap(URL(string: "https://example.com"))
        let expectation = XCTestExpectation(description: "Decoding failed error")
        let invalidData = Data("Invalid JSON data".utf8)
        let urlResponse = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            return (urlResponse, invalidData)
        }
        // When
        let network = Network(session: urlSession)
        let cancellable = network.fetch(request: URLRequest(url: url), decodableType: DummyDecodable.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't succeed")
                case .failure(let error):
                    // Then
                    if case NetworkError.decodingFailed = error {
                        expectation.fulfill()
                    }
                }
            }, receiveValue: { _ in })
        
        // Then
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
    
    func testFetch_NotConnectedToInternet() throws {
        // Given
        let expectation = XCTestExpectation(description: "Not connected to internet error")
        let network = Network(session: urlSession)
        MockURLProtocol.error = URLError(.notConnectedToInternet)
        let url: URL = try XCTUnwrap(URL(string: "https://example.com"))

        // When
        let cancellable = network.fetch(request: URLRequest(url: url))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't succeed")
                case .failure(let error):
                    // Then
                    if case NetworkError.notConnectedToInternet = error {
                        expectation.fulfill()
                    }
                }
            }, receiveValue: { _ in })
        
        // Then
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
}

struct DummyDecodable: Decodable {}

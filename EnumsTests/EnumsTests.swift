//
//  EnumsTests.swift
//  EnumsTests
//
//  Created by Fernando Olivares on 10/26/20.
//

import XCTest
@testable import Networking_Take_Home_Interview

class EnumsTests: XCTestCase {
	
	func testSuccessfulRequest() {
        // Expected success; The Happy Path™
		let mockServer = MockNetworkController(data: validData,
											   response: validResponse,
											   error: nil)
        networkCall(mockServer) { (possiblePerson, possibleError) in
            XCTAssertNotNil(possiblePerson)
            XCTAssertNil(possibleError)
        }
	}
    
    func testNetworkError() {
        // Network error; see NSURLError.h
        let errorScenario = MockNetworkController(data: nil,
                                                  response: nil,
                                                  error: validError)
        networkCall(errorScenario) { (possiblePerson, possibleError) in
            XCTAssertNil(possiblePerson)
            XCTAssertNotNil(possibleError)
        }
    }
    
    func testiOSDevHumanError() {
        // Sounds impossible, but iOS devs also make mistakes.
        // e.g. HTTP 400 (Bad Request)
        let errorScenario = MockNetworkController(data: invalidData,
                                                  response: invalidResponse,
                                                  error: nil)
        networkCall(errorScenario) { (possiblePerson, possibleError) in
            XCTAssertNil(possiblePerson)
            XCTAssertNotNil(possibleError)
        }
    }
    
    func testBackendDevHumanError() {
        // Programming is hard 🤷🏻‍♂️
        let errorScenarios = [
            MockNetworkController(data: invalidData, response: validResponse, error: nil), // Returned 200 with invalid data
            MockNetworkController(data: nil, response: validResponse, error: nil), // Returned 200 but no data
            MockNetworkController(data: validData, response: invalidResponse, error: nil), // Returned 300+ but valid data
            MockNetworkController(data: nil, response: invalidResponse, error: validError), // e.g. too many redirects (HTTP 302)
            MockNetworkController(data: nil, response: invalidResponse, error: nil), // e.g. HTTP 500 (Server Error)
        ]
        
        for scenario in errorScenarios {
            networkCall(scenario) { (possiblePerson, possibleError) in
                XCTAssertNil(possiblePerson)
                XCTAssertNotNil(possibleError)
            }
        }
    }
    
    func testInvalidStateMissingResponse() {
        // When consuming an API, an HTTP response is expected.
        let errorScenarios = [
            MockNetworkController(data: invalidData, response: nil, error: nil), // Server did not return an HTTP response.
            MockNetworkController(data: validData, response: nil, error: nil), // Server did not return an HTTP response.
            MockNetworkController(data: validData, response: nil, error: validError), // Server did not return an HTTP response.
            MockNetworkController(data: invalidData, response: nil, error: validError), // Could be `NSURLErrorBadServerResponse`.
        ]
        
        for scenario in errorScenarios {
            networkCall(scenario) { (possiblePerson, possibleError) in
                XCTAssertNil(possiblePerson)
                XCTAssertNotNil(possibleError)
            }
        }
    }

	func testInvalidStateShouldNeverHappen() {
        // All of these don't make sense, but due to the fact that we're using 3 optionals, they _could_ happen.
        let errorScenarios = [
            MockNetworkController(data: nil, response: nil, error: nil), // Apple framework error?
            MockNetworkController(data: invalidData, response: validResponse, error: validError), // Apple framework error?
            MockNetworkController(data: nil, response: validResponse, error: validError), // Apple framework error?
            MockNetworkController(data: validData, response: validResponse, error: validError), // Apple framework error?
            MockNetworkController(data: validData, response: invalidResponse, error: validError), // Apple framework error?
            MockNetworkController(data: invalidData, response: invalidResponse, error: validError), // Maybe `NSURLErrorBadServerResponse`?
        ]
        
        for scenario in errorScenarios {
            networkCall(scenario) { (possiblePerson, possibleError) in
                XCTAssertNil(possiblePerson)
                XCTAssertNotNil(possibleError)
            }
        }
	}
}

extension EnumsTests {
	
	var validData: Data {
		let success = [ "name": "Luke Skywalker" ]
		return try! JSONEncoder().encode(success)
	}
    
    var invalidData: Data {
        let success = [ "name": 123 ]
        return try! JSONEncoder().encode(success)
    }
	
	var validResponse: URLResponse {
		return HTTPURLResponse(url: URL(string: "https://fromjuniortosenior.com")!,
							   statusCode: 200,
							   httpVersion: nil,
                               headerFields: nil)!
	}
    
    var invalidResponse: URLResponse {
        HTTPURLResponse(url: URL(string: "https://fromjuniortosenior.com")!,
                               statusCode: 500,
                               httpVersion: nil,
                               headerFields: nil)!
    }
	
	var validError: Error {
		return NSError(domain: "Enums App",
					   code: -1,
					   userInfo: nil)
	}
	
    private func networkCall(_ controller: NetworkPlaceholder,
                             completion: @escaping (NetworkPerson?, Error?) -> Void) {
        
		let expectation = self.expectation(description: "Waiting...")
		let network = NetworkController(network: controller)
		network.fetch { (possiblePerson, possibleError) in
			completion(possiblePerson, possibleError)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 2) { _ in
            
		}
	}
}

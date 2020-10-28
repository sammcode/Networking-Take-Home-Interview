//
//  EnumsTests.swift
//  EnumsTests
//
//  Created by Fernando Olivares on 10/26/20.
//

import XCTest
@testable import Enums

class EnumsTests: XCTestCase {
	
	/// Expected success; The Happy Path™
	/// [nilError,validData,validCode]
	func testSuccessfulRequest() {
		let mockServer = SuccessMockNetworkController(data: validData,
													  response: validResponse,
													  error: nil)
		let network = NetworkController(network: mockServer)
		network.fetch { (possiblePerson, possibleError) in
			XCTAssertNotNil(possiblePerson)
			XCTAssertNil(possibleError)
		}
	}
	
	/// Server did not return an HTTP code
	/// Weird, but successful nonetheless
	/// [nilError,validData,nilCode]
	func testValidDataNilCode() {
		
	}
	
	/// [NSURLError] (https://github.com/apportable/Foundation/blob/master/System/Foundation/include/Foundation/NSURLError.h)
	/// More than likely it's a connection error of some sort; report is as is.
	///
	///	[validError,validData,validCode]
	///	[validError,validData,invalidCode]
	///	[validError,validData,nilCode]
	///	[validError,invalidData,validCode]
	///	[validError,invalidData,invalidCode]
	///	[validError,invalidData,nilCode]
	///	[validError,nilData,validCode]
	///	[validError,nilData,invalidCode]
	///	[validError,nilData,nilCode]
	func testValidErrorCombinations() {
		
	}
	
	/// HTTP Code Error
	/// Server returned something other than a 200.
	/// In theory, we should handle each code distinctly, but for now just report unexpected HTTP code.
	///	[nilError,validData,invalidCode]
	///	[nilError,invalidData,invalidCode]
	///	[nilError,nilData,invalidCode]
	func testInvalidHTTPCodeCombinations() {
		
	}
	
	/// Server logic error
	/// Our service returned invalid, corrupt, or nonexistent data
	///	[nilError,invalidData,nilCode]
	///	[nilError,invalidData,validCode]
	///	[nilError,nilData,validCode]
	func testInvalidDataFromServer() {
		
	}
	
	/// Invalid state. Should never happen.
	/// [nilError,nilData,nilCode]
	func invalidState() {
		
	}
}

extension EnumsTests {
	
	var validData: Data {
		let successString = "{ \"name\": \"Luke Skywalker\" }"
		return try! JSONEncoder().encode(successString)
	}
	
	var validResponse: URLResponse? {
		return HTTPURLResponse(url: URL(string: "https://fromjuniortosenior.com")!,
							   statusCode: 200,
							   httpVersion: nil,
							   headerFields: nil)
	}
}

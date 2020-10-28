//
//  MockNetworkController.swift
//  EnumsTests
//
//  Created by Fernando Olivares on 10/27/20.
//

import Foundation
@testable import Enums

class SuccessMockNetworkController : NetworkPlaceholder {
	
	let data: Data?
	let response: URLResponse?
	let error: Error?
	
	init(data: Data?, response: URLResponse?, error: Error?) {
		self.data = data
		self.response = response
		self.error = error
	}
	
	func get(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
			completionHandler(self.data, self.response, self.error)
		}
	}
}

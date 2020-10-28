//
//  URLSession+NetworkPlaceholder.swift
//  Enums
//
//  Created by Fernando Olivares on 10/27/20.
//

import Foundation

extension URLSession : NetworkPlaceholder {
	
	func get(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let newTask = dataTask(with: request, completionHandler: completionHandler)
		newTask.resume()
	}
}

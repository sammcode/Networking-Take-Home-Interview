//
//  NetworkController.swift
//  Enums
//
//  Created by Fernando Olivares on 10/26/20.
//

import Foundation

protocol NetworkPlaceholder {
	func get(request: URLRequest,
			 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkController {
	
	let network: NetworkPlaceholder
	init(network: NetworkPlaceholder = URLSession.shared) {
		self.network = network
	}
	
	func fetch(completion: @escaping (NetworkPerson?, Error?) -> Void) {
		let url = URL(string: "https://swapi.dev/api/people/1")!
		let request = URLRequest(url: url)
		network.get(request: request) { (possibleData, possibleResponse, possibleError) in
			
		}
	}
}

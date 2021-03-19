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

enum NetworkError: Error {
    case invalidData
    case missingResponse
    case invalidResponse
    case unableToComplete
    case decodingError(Error)

    var errorDescription: String{
        switch self {
        case .invalidData: return "The data received from the server was invalid."
        case .missingResponse: return "There was no response recieved."
        case .invalidResponse: return "Invalid response from the server."
        case .unableToComplete: return "Could not complete your request at this time. Please check your connection!"
        case .decodingError(let error): return "Error decoding: + \(error.localizedDescription)"
        }
    }
}

class NetworkController {

    let url: URL
	
	let network: NetworkPlaceholder
    init(network: NetworkPlaceholder = URLSession.shared, baseURL: URL) {
		self.network = network
        self.url = baseURL
	}
	
	func fetch(completion: @escaping (Result<NetworkPerson, NetworkError>) -> Void) {
		let request = URLRequest(url: url)
		network.get(request: request) { (data, response, error) in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.missingResponse))
                return
            }

            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(NetworkPerson.self, from: data)
                completion(.success(person))
            }catch {
                completion(.failure(.decodingError(error)))
            }
		}
	}
}

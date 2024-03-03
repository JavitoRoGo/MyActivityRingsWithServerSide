//
//  HTTPClient.swift
//  MyActivityRingsWithServerSide
//
//  Created by Javier Rodríguez Gómez on 6/12/23.
//

import Foundation

enum HTTPMethod {
	case get
	case post(Data?)
	case delete
	
	var name: String {
		switch self {
			case .get: "GET"
			case .post: "POST"
			case .delete: "DELETE"
		}
	}
}

enum NetworkError: Error {
	case badRequest
	case serverError(String)
	case decodingError
	case invalidResponse
}

struct Resource<T: Codable> {
	let url: URL
	var method: HTTPMethod = .get
	var modelType: T.Type
}

struct HTTPClient {
	private let headers = ["Content-Type": "application/json"]
	
	func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
		var request = URLRequest(url: resource.url)
		switch resource.method {
			case .get:
				let components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
				guard let url = components?.url else { throw NetworkError.badRequest }
				request = URLRequest(url: url)
			case .post(let data):
				request.httpMethod = resource.method.name
				request.httpBody = data
			case .delete:
				request.httpMethod = resource.method.name
		}
		
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = headers
		let session = URLSession(configuration: configuration)
		
		let (data, response) = try await session.data(for: request)
		
		guard let _ = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		guard let result = try? decoder.decode(resource.modelType, from: data) else { throw NetworkError.decodingError }
		return result
	}
}

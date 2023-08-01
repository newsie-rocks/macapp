//
//  ApiClient.swift
//  xos
//
//  Created by nick on 01/08/2023.
//

import Foundation

struct ReqResult: Codable {
    let id: String
    let name: String
}

struct Album: Codable, Hashable {
    let collectionId: Int
    let collectionName: String
    let collectionPrice: Double
}

enum ApiClientError: Error {
    case invalidParam(String)
    case server(String)
    case unhandled(String)
}

/// API client
class ApiClient {
    /// Base URL
    let baseUrl: String

    init(baseUrl: String?) {
        self.baseUrl = baseUrl ?? "http://localhost:3000"
    }

    /// Sends a request
    func sendDummyRequest(album: Album) async -> Result<ReqResult, ApiClientError> {
        do {
            let url = baseUrl + "/hello"
            guard let url = URL(string: url) else {
                return  .failure(ApiClientError.invalidParam("invalid URL: \(url)"))
            }

            let body = try JSONEncoder().encode(album)
            var request = URLRequest(url: url)
            request.addValue("ABCD", forHTTPHeaderField: "X-API-Demo")
            request.httpBody = body

            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(ApiClientError.server("not an HTTP response"))
            }
            if urlResponse.statusCode < 400 {
                let result = try JSONDecoder().decode(ReqResult.self, from: data)
                return .success(result)
            } else {
                let errorMessage = try JSONDecoder().decode(String.self, from: data)
                return .failure(ApiClientError.server(errorMessage))
            }
        } catch {
            return .failure(ApiClientError.unhandled(error.localizedDescription))
        }
    }
}

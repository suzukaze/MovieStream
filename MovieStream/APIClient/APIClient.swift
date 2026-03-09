//
//  APIClient.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/07.
//

import Foundation

protocol URLSessionForAPIClient {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionForAPIClient {}

final class APIClient {
    private let session: URLSessionForAPIClient
    
    init(session: URLSessionForAPIClient) {
        self.session = session
    }
    
    func request<Request>(_ request: Request) async throws -> Request.Response where Request: Requestable {
        guard let urlRequest = request.makeURLRequest() else {
            throw APIClientError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest, delegate: nil)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.httpResponseFailed
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard !data.isEmpty else {
                    throw APIClientError.noData
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(Request.Response.self, from: data)
                    return decodedResponse
                } catch {
                    throw APIClientError.decodeFailed(error)
                }
            case 400..<500:
                throw APIClientError.client(statusCode: httpResponse.statusCode)
            case 500..<600:
                throw APIClientError.server(statusCode: httpResponse.statusCode)
            default:
                throw APIClientError.unknownStatus(statusCode: httpResponse.statusCode)
            }
        } catch {
            throw APIClientError.requestFailed(error)
        }
    }
}

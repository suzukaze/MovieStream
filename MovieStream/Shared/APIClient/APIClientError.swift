//
//  APIClientError.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/07.
//

import Foundation

enum APIClientError: Error, Equatable {
    case invalidURL
    case httpResponseFailed
    case decodeFailed(Error)
    case client(statusCode: Int)
    case server(statusCode: Int)
    case unknownStatus(statusCode: Int)
    case requestFailed(Error)
    case noData
    
    public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.httpResponseFailed, .httpResponseFailed),
            (.noData, .noData):
            return true
        case let (.decodeFailed(lhsError), .decodeFailed(rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case let (.client(lhsCode), .client(rhsCode)),
            let (.server(lhsCode), .server(rhsCode)),
            let (.unknownStatus(lhsCode), .unknownStatus(rhsCode)):
            return lhsCode == rhsCode
        case let (.requestFailed(lhsError), .requestFailed(rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default:
            return false
        }
    }
}

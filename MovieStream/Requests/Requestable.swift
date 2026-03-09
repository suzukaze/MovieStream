//
//  Requestable.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/07.
//

import Foundation

protocol Requestable {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: HttpMethod { get }
    func makeURLRequest() -> URLRequest?
}

enum HttpMethod: String {
    case get
    case post
}

extension Requestable {
    func makeURLRequest() -> URLRequest? {
        guard let baseURL = URL(string: path, relativeTo: baseURL) else {
            return nil
        }
        
        guard let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        var mutableComponents = components
        mutableComponents.queryItems = queryItems
        guard let absoluteURL = mutableComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: absoluteURL)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}

//
//  FetchMoviesRequest.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/14.
//

import Foundation

struct FetchMoviesRequest: Requestable {
    typealias Response = FetchMoviesResponse
    var baseURL: URL = Constants.apiBaseURL
    var path: String = "movies"
    var queryItems: [URLQueryItem]? = nil
    var httpMethod: HttpMethod = .get
}

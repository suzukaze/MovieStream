//
//  SearchMoviesRequest.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/12.
//

import Foundation

struct SearchMoviesRequest: Requestable {
    typealias Response = SearchMoviesResponse
    var baseURL: URL = Constants.apiBaseURL
    var path: String = "movies/search"
    var queryItems: [URLQueryItem]? = nil
    var httpMethod: HttpMethod = .get
    
    init(keyword: String) {
        self.queryItems = [
            .init(name: "keyword", value: keyword)
        ]
    }
}

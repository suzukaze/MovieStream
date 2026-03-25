//
//  FetchGenresRequest.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/08.
//

import Foundation

struct FetchGenresRequest: Requestable {
    typealias Response = FetchGenresResponse
    var baseURL: URL = Constants.apiBaseURL
    var path: String = "genres"
    var queryItems: [URLQueryItem]? = nil
    var httpMethod: HttpMethod = .get
}

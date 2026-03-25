//
//  SearchRepository.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/24.
//

import Foundation

final class SearchRepository {
    static let shared = SearchRepository()
    let apiClient: APIClient = APIClient(session: URLSession.shared)
    
    private init() {
    }
    
    func searchMovies(by keyword: String) async throws -> SearchMoviesRequest.Response {
        try await apiClient.request(SearchMoviesRequest(keyword: keyword))
    }
}

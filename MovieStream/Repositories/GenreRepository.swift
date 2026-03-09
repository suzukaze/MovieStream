//
//  GenreRepository.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/06.
//

import Foundation

final class GenreRepository {
    static let shared = GenreRepository()
    let apiClient: APIClient = APIClient(session: URLSession.shared)

    private init() {
    }
    
    func fetchGenres() async throws -> FetchGenresRequest.Response {
        try await apiClient.request(FetchGenresRequest())
    }
}

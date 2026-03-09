//
//  SearchViewModel.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/24.
//

import UIKit

final class SearchViewModel: ObservableObject {
    @Published var thumbnails: [Int64: UIImage] = [:]
    var genres: [Genre]?

    init() {
        Task {
            do {
                let genreResponse = try await GenreRepository.shared.fetchGenres()
                genres = genreResponse.genres
            } catch {
            }
        }
    }

    func searchMovies(by keyword: String) async throws -> SearchMoviesRequest.Response {
        try await SearchRepository.shared.searchMovies(by: keyword)
    }
    
    func thumbnailImage(for movie: Movie) async throws -> UIImage? {
        try await MoviesRepository.thumbnailImage(for: movie)
    }
}

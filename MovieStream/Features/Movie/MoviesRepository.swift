//
//  MoviesRepository.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/03.
//

import UIKit

final class MoviesRepository {
    static let shared = MoviesRepository()
    let apiClient: APIClient = APIClient(session: URLSession.shared)
    
    private init() {
    }
    
    func fetchMovies() async throws -> FetchMoviesResponse {
        try await apiClient.request(FetchMoviesRequest())
    }
    
    static func thumbnailImage(for movie: Movie, isServer: Bool = true) async throws -> UIImage? {
        if isServer {
            let url = Constants.resourcesURL.appending(component: movie.thumbnailUrlString)
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } else {
            guard let result = StringUtils.splitFilename(movie.thumbnailUrlString),
                  let url = Bundle.main.url(forResource: result.name, withExtension: result.ext) else {
                return nil
            }
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        }
    }
}

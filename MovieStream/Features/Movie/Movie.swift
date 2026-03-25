//
//  Movie.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/01.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable {
    let id: Int64
    let title: String
    let genreId: Int64?
    let urlString: String
    let thumbnailUrlString: String
    let createdAt: String
    let updatedAt: String
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

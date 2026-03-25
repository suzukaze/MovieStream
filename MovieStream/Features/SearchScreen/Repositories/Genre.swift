//
//  Genre.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/06.
//

import Foundation

struct Genre: Codable, Identifiable {
    let id: Int64
    let name: String
    let createdAt: String
    let updatedAt: String
}

//
//  Constants.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/31.
//

import Foundation

struct Constants {
    static let serverURL = URL(string: "http://localhost:3000")!
    static let resourcesURL = serverURL.appending(component: "resources", directoryHint: .isDirectory)
    static let apiBaseURL = serverURL
        .appending(component: "api", directoryHint: .isDirectory)
        .appending(component: "v1", directoryHint: .isDirectory)
}

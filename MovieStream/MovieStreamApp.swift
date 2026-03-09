//
//  MovieStreamApp.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/01.
//

import SwiftUI

@main
struct MovieStreamApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @State private var didInit = false

    var body: some Scene {
        WindowGroup {
            MainTabView(coordinator: coordinator)
                .onAppear {
                    if !didInit {
                        coordinator.goMovieScreen()
                        didInit = true
                    }
                }
        }
    }
}

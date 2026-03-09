//
//  AppCoordinator.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/08/13.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var selectedTab: TabSelection = .movie
    @ObservedObject var movieViewModel = MovieViewModel()

    func play(movie: Movie) {
        movieViewModel.play(movie: movie)
        selectedTab = .movie
    }
    
    func goMovieScreen() {
        selectedTab = .movie
    }
}

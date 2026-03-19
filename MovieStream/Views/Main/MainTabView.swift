//
//  MainTabView.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/02.
//

import SwiftUI

enum TabSelection: Hashable {
    case movie
    case search
}

struct MainTabView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            MovieView(viewModel: coordinator.movieViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(String(localized: "movie.screen.name"))
                }
                .tag(TabSelection.movie)
            SearchView(coordinator: coordinator)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(String(localized: "search.screen.name"))
                }
                .tag(TabSelection.search)
        }
    }
}

#Preview {
    MainTabView(coordinator: AppCoordinator())
}

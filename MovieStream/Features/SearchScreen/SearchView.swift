//
//  SearchView.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var movies: [Movie] = []
    @State private var thumbnails: [Int64: UIImage] = [:]
    @State private var isLoading = false
    @State private var keyword: String = ""
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            TextField(String(localized: "search.screen.message"), text: $keyword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    Task {
                        await performSearch()
                    }
                }
            
            if isLoading {
                ProgressView()
                    .padding()
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        Button(action: {
                            coordinator.play(movie: movie)
                        }) {
                            if let image = viewModel.thumbnails[movie.id]{
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: UIScreen.main.bounds.width)
                            } else {
                                // 画像がなかった場合のプレースホルダー
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 160, height: 90)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                    )
                                    .task {
                                        do {
                                            if let image = try await viewModel.thumbnailImage(for: movie) {
                                                viewModel.thumbnails[movie.id] = image
                                            }
                                        } catch {
                                        }
                                    }

                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    private func performSearch() async {
        guard !keyword.isEmpty else {
            return
        }
        
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let response = try await viewModel.searchMovies(by: keyword)
            movies = response.movies
        } catch {
        }
    }
}

#Preview {
    SearchView(coordinator: AppCoordinator())
}

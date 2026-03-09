//
//  MovieView.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/01.
//

import SwiftUI
import AVFoundation

struct MovieView: View {
    @StateObject var viewModel = MovieViewModel()
    @State private var showSheet = false
    @State private var isLoading = false
    @State private var hasFetched = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    CustomPlayerView(player: viewModel.player)
                        .frame(height: 300)
                        .padding(.top, 40)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.onPlayerTap()
                        }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(2.0)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(.clear)
                    }
                    
                    if viewModel.showPlayerMenu {
                        Button(action: {
                            viewModel.onPlayButtonTap()
                        }) {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Text("\(StringUtils.timeString(from: viewModel.currentTime))/\(StringUtils.timeString(from: viewModel.duration))")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                            .padding(.bottom, 60)
                            .shadow(radius: 4)
                    }
                    VStack {
                        HStack {
                            ColorSlider(
                                value: $viewModel.currentTime,
                                in: 0...viewModel.duration,
                                onEditingChanged:  { isEditing in
                                    if isEditing {
                                        viewModel.beginSeeking()
                                    } else {
                                        viewModel.endSeeking()
                                    }
                                }
                            )
                            .onChange(of: viewModel.currentTime) {
                                if !viewModel.isPlaying {
                                    viewModel.seek(to: viewModel.currentTime)
                                }
                            }
                            if viewModel.showMuteButton {
                                Button(action: {
                                    viewModel.isMuted.toggle()
                                }) {
                                    Image(systemName: viewModel.isMuted ? "speaker.slash" : "speaker.wave.2")
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
                .frame(height: 300)
                .padding(.horizontal, 10)
                if viewModel.showPlayerMenu {
                    Button(action: {
                        showSheet = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                    .padding(.top, 70)
                    .padding(.trailing, 16)
                }
            }
            .frame(height: 300)
            .sheet(isPresented: $showSheet) {
                MovieSettingsSheet(showSheet: $showSheet, playbackRate: $viewModel.playbackRate)
                    .presentationDetents([.height(250)])
            }
            Text(viewModel.title)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .padding(.horizontal, 10)
            ScrollView {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(2.0)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(.clear)
                    }
                    ForEach(viewModel.otherMovies.prefix(4), id: \.id) { movie in
                        Button(action: {
                            viewModel.play(movie: movie)
                        }) {
                            if let image = viewModel.thumbnails[movie.id]{
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: UIScreen.main.bounds.width)
                            } else {
                                // 画像がなかった場合のプレースホルダー
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray.opacity(0.4))
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
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            
            Spacer()
        }
        .background(.white)
        .edgesIgnoringSafeArea(.top)
        .task {
            if !hasFetched {
                hasFetched = true
                isLoading = true
                await fetchMovies()
                isLoading = false
                
                if let movie = viewModel.movies.first {
                    viewModel.play(movie: movie)
                }
            }
        }
    }
    
    private func fetchMovies() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchMovies()
            viewModel.movies = response.movies
        } catch {
        }
    }
}

#Preview {
    MovieView()
}

//
//  MovieViewModel.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/01.
//

import SwiftUI
import AVFoundation
import Combine

final class MovieViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var playbackRate: Float = 1.0 {
        didSet {
            updatePlaybackRate()
        }
    }
    @Published var isMuted = true {
        didSet {
            player.isMuted = isMuted
        }
    }
    @Published var showPlayerMenu = false
    @Published var isLoading = false
    @Published var movies: [Movie] = []
    @Published var thumbnails: [Int64: UIImage] = [:]
    
    var title: String {
        movie?.title ?? ""
    }

    var otherMovies: [Movie] {
        movies.filter { $0 != movie }
    }
    
    private(set) var player: AVPlayer = AVPlayer()
    private var timeObserverToken: Any?
    var movie: Movie?
    var showMuteButton = true
    private var wasPlayingBeforeSeek = false
    private var isSeeking = false
    private var cancellables = Set<AnyCancellable>()
    private var playerItemDidPlayToEndSubscriber: AnyCancellable?

    deinit {
        removePlayerObserverIfNeeded()
    }

    func observePlayerItemDidPlayToEnd(item: AVPlayerItem) {
        playerItemDidPlayToEndSubscriber = NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .sink { [weak self] _ in
                self?.playerDidFinishPlaying()
            }
        playerItemDidPlayToEndSubscriber?.store(in: &cancellables)
    }

    static func playerItem(movie: Movie, isServer: Bool = true) -> AVPlayerItem {
        if isServer {
            let url = Constants.resourcesURL.appending(component: movie.urlString)
            return AVPlayerItem(url: url)
        } else  {
            let result = StringUtils.splitFilename(movie.urlString)
            let url = Bundle.main.url(forResource: result!.name, withExtension: result!.ext)!
            return AVPlayerItem(url: url)
        }
    }
    
    func play(movie: Movie) {
        isLoading = true
        
        removePlayerObserverIfNeeded()
        
        self.movie = movie
        let item = Self.playerItem(movie: movie)
        player = AVPlayer(playerItem: item)
        
        isPlaying = false
        isMuted = showMuteButton
        player.isMuted = isMuted
        
        player.seek(to: .zero) { [weak self] _ in
            Task { @MainActor in
                self?.currentTime = 0
            }
        }
        
        observePlayerItemDidPlayToEnd(item: item)
        setupPlayerObserver()
        loadDuration()
        
        player.currentItem?.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }

    func onPlayerTap() {
        showPlayerMenu = true
        hidePlayerMenuLaterIfNeeded()
    }
    
    func onPlayButtonTap() {
        togglePlay()
        hidePlayerMenuLaterIfNeeded()
    }

    func beginSeeking() {
        isSeeking = true
        wasPlayingBeforeSeek = isPlaying
        if isPlaying {
            player.pause()
            isPlaying = false
        }
    }
    
    func endSeeking() {
        isSeeking = false
        if wasPlayingBeforeSeek {
            player.play()
            isPlaying = true
        }
    }
    
    private func togglePlay() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
            player.rate = playbackRate
        }
        isPlaying.toggle()
    }

    func seek(to seconds: Double) {
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 600))
    }

    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
    }
    
    private func updatePlaybackRate() {
        if isPlaying {
            player.rate = playbackRate
        }
    }

    private func hidePlayerMenuLaterIfNeeded() {
        if isPlaying {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if self.isPlaying {
                    self.showPlayerMenu = false
                }
            }
        }
    }

    private func setupPlayerObserver() {
        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.05, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self else {
                return
            }
            
            if !self.isSeeking {
                self.currentTime = time.seconds
            }
        }
    }

    private func removePlayerObserverIfNeeded() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    private func loadDuration() {
        guard let asset = player.currentItem?.asset else {
            return
        }

        Task {
            do {
                let duration = try await asset.load(.duration)
                let seconds = duration.seconds
                if seconds.isFinite && seconds > 0 {
                    await MainActor.run {
                        self.duration = seconds
                    }
                }
            } catch {
            }
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        isPlaying = false
    }
    
    func thumbnailImage(for movie: Movie) async throws -> UIImage? {
        try await MoviesRepository.thumbnailImage(for: movie)
    }
    
    func fetchMovies() async throws -> FetchMoviesResponse {
        try await MoviesRepository.shared.fetchMovies()
    }
}

//
//  FavoriteSongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import MediaPlayer

@MainActor
class FavoriteSongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    private let favoriteSongsService: FavoriteSongsServiceProtocol

    init(favoriteSongsService: FavoriteSongsServiceProtocol = FavoriteSongsService()) {
        self.favoriteSongsService = favoriteSongsService
    }

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            songs = favoriteSongsService.findAll()
        }
    }
}

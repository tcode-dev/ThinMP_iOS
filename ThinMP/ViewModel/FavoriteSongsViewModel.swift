//
//  FavoriteSongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import Combine

@MainActor
class FavoriteSongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    private let favoriteSongsService: FavoriteSongsServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(favoriteSongsService: FavoriteSongsServiceProtocol = FavoriteSongsService()) {
        self.favoriteSongsService = favoriteSongsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let songs = await favoriteSongsService.findAll()

            if Task.isCancelled { return }

            self.songs = songs
        }

        loadTask = task

        return task
    }
}

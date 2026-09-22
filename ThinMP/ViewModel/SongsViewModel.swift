//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import Combine

@MainActor
class SongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    private let songsService: SongsServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(songsService: SongsServiceProtocol = SongsService()) {
        self.songsService = songsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let songs = await Task.detached(priority: .userInitiated) { [songsService] in
                songsService.findAll()
            }.value

            if Task.isCancelled { return }

            self.songs = songs
        }

        loadTask = task

        return task
    }
}

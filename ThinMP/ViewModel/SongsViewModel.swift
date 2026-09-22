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
    private let loadTask = LoadTask()

    init(songsService: SongsServiceProtocol = SongsService()) {
        self.songsService = songsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [songsService] in
            await songsService.findAll()
        } apply: { [weak self] songs in
            self?.songs = songs
        }
    }
}

//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import Observation

@Observable
final class SongsViewModel {
    private(set) var songs: [SongModel] = []

    private let songsService: SongsServiceProtocol
    private let loadTask = LoadTask()

    init(songsService: SongsServiceProtocol = SongsService()) {
        self.songsService = songsService
    }

    func load() async {
        await loadTask.run {
            await songsService.findAll()
        } apply: { songs in
            self.songs = songs
        }
    }
}

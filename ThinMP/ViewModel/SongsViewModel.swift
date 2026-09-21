//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

@MainActor
class SongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    private let songsService: SongsServiceProtocol

    init(songsService: SongsServiceProtocol = SongsService()) {
        self.songsService = songsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            songs = await Task.detached(priority: .userInitiated) { [songsService] in
                songsService.findAll()
            }.value
        }
    }
}

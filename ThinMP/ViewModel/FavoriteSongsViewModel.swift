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

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            songs = await favoriteSongsService.findAll()
        }
    }
}

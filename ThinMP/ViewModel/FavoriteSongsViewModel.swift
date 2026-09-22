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
    private let favoriteSongRepository: FavoriteSongRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        favoriteSongsService: FavoriteSongsServiceProtocol = FavoriteSongsService(),
        favoriteSongRepository: FavoriteSongRepositoryProtocol = FavoriteSongRepository()
    ) {
        self.favoriteSongsService = favoriteSongsService
        self.favoriteSongRepository = favoriteSongRepository
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [favoriteSongsService] in
            await favoriteSongsService.findAll()
        } apply: { [weak self] songs in
            self?.songs = songs
        }
    }

    /// 編集ページの並び順と削除を保存する
    func save() {
        favoriteSongRepository.update(songIds: songs.map { $0.songId })
    }
}

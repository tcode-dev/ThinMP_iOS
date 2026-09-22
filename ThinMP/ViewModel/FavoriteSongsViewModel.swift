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
    /// 1 回目の読み込みが終わったか。終わるまでは編集ページの保存を受け付けない
    @Published private(set) var isLoaded = false

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
            self?.isLoaded = true
        }
    }

    /// 編集ページの並び順と削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の songs で上書きするとお気に入りが全部消える)
    func save() {
        guard isLoaded else {
            return
        }

        favoriteSongRepository.update(songIds: songs.map { $0.songId })
    }
}

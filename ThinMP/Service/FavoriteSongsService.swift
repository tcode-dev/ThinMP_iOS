//
//  FavoriteSongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteSongsService: FavoriteSongsServiceProtocol {
    private let favoriteSongRepository: FavoriteSongRepositoryProtocol
    private let songRepository: SongRepositoryProtocol
    private let favoriteSongRegister: FavoriteSongRegisterProtocol

    init(
        favoriteSongRepository: FavoriteSongRepositoryProtocol = FavoriteSongRepository(),
        songRepository: SongRepositoryProtocol = SongRepository(),
        favoriteSongRegister: FavoriteSongRegisterProtocol = FavoriteSongRegister()
    ) {
        self.favoriteSongRepository = favoriteSongRepository
        self.songRepository = songRepository
        self.favoriteSongRegister = favoriteSongRegister
    }

    func findAll() async -> [SongModel] {
        let songIds = favoriteSongRepository.findAll()
        // ライブラリ全件を舐めるので、SwiftData の読み書きだけメインアクターに残してスキャンはバックグラウンドで行う
        let songs = await Task.detached(priority: .userInitiated) { [songRepository] in
            songRepository.findByIds(songIds: songIds)
        }.value

        // 端末から削除された曲がお気に入りに残っている場合は取り除いて保存する
        if songs.count != songIds.count {
            favoriteSongRegister.update(songIds: songs.map { $0.songId })
        }

        return songs
    }
}

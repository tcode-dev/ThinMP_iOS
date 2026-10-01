//
//  FavoriteSongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteSongsService: FavoriteSongsServiceProtocol {
    private let favoriteSongRepository: FavoriteSongRepositoryProtocol
    private let songRepository: SongRepositoryProtocol

    init(
        favoriteSongRepository: FavoriteSongRepositoryProtocol = FavoriteSongRepository(),
        songRepository: SongRepositoryProtocol = SongRepository()
    ) {
        self.favoriteSongRepository = favoriteSongRepository
        self.songRepository = songRepository
    }

    func findAll() async -> [SongModel] {
        let songIds = favoriteSongRepository.findAll()
        // ライブラリ全件を走査するので、SwiftData の読み書きだけメインアクターに残してスキャンはバックグラウンドで行う
        let songs = await Self.findSongs(songIds: songIds, songRepository: songRepository)

        // 端末から削除された曲がお気に入りに残っている場合は、その曲だけ取り除く
        // 一覧ごと上書きすると、走査中に(再生画面などで)登録された曲まで消える
        let foundIds = Set(songs.map { $0.songId })

        for songId in songIds where !foundIds.contains(songId) {
            favoriteSongRepository.delete(songId: songId)
        }

        return songs
    }

    /// ライブラリを走査するのでバックグラウンドで行う
    @concurrent
    private static func findSongs(songIds: [SongId], songRepository: SongRepositoryProtocol) async -> [SongModel] {
        return songRepository.findByIds(songIds: songIds)
    }
}

//
//  PlaylistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

struct PlaylistDetailService: PlaylistDetailServiceProtocol {
    private let playlistRepository: PlaylistRepositoryProtocol
    private let songRepository: SongRepositoryProtocol

    init(
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository(),
        songRepository: SongRepositoryProtocol = SongRepository()
    ) {
        self.playlistRepository = playlistRepository
        self.songRepository = songRepository
    }

    /// 削除済みのプレイリストなら nil
    func findById(playlistId: PlaylistId) async -> PlaylistDetailModel? {
        guard let playlist = playlistRepository.findById(playlistId: playlistId) else {
            return nil
        }

        return await createModels(playlists: [playlist]).first
    }

    func findByIds(playlistIds: [PlaylistId]) async -> [PlaylistDetailModel] {
        let playlists = playlistRepository.findByIds(playlistIds: playlistIds)

        return await createModels(playlists: playlists)
    }

    func findAll() async -> [PlaylistDetailModel] {
        return await createModels(playlists: playlistRepository.findAll())
    }

    /// 全プレイリストの曲をまとめて 1 回で取り、プレイリストごとに振り分ける
    /// SongRepository.findByIds はライブラリ全件を走査するので、プレイリストごとに呼ばない
    /// スキャンはバックグラウンドで行い、SwiftData の読み書きだけメインアクターに残す
    private func createModels(playlists: [PlaylistEntity]) async -> [PlaylistDetailModel] {
        let songIds = playlists.flatMap { $0.songIds }.uniqued()
        let (librarySongs, deletedIds) = await Self.findSongs(songIds: songIds, songRepository: songRepository)
        let songById = librarySongs.keyed { $0.songId }

        let models = playlists.map { playlist in
            let songs = playlist.songIds.compactMap { songById[$0] }

            return PlaylistDetailModel(playlistId: playlist.playlistId, primaryText: playlist.name, artwork: songs.firstArtwork, songs: songs)
        }

        // 端末から削除された曲がプレイリストに残っている場合は、その曲だけ取り除く
        // クラウドにしか無い曲(端末から外されただけの曲)は一覧には出さないが、ダウンロードし直せば戻るように残す
        for playlist in playlists {
            let removedSongIds = Set(playlist.songIds.filter { deletedIds.contains($0) })

            if !removedSongIds.isEmpty {
                removeSongs(playlistId: playlist.playlistId, songIds: removedSongIds)
            }
        }

        return models
    }

    /// 見つかった曲と、見つからなかった曲のうちクラウドにも無いもの。ライブラリを走査するのでバックグラウンドで行う
    @concurrent
    private static func findSongs(songIds: [SongId], songRepository: SongRepositoryProtocol) async -> ([SongModel], Set<SongId>) {
        let songs = songRepository.findByIds(songIds: songIds)
        let foundIds = Set(songs.map { $0.songId })

        return (songs, songRepository.findDeletedIds(songIds: songIds.filter { !foundIds.contains($0) }))
    }

    /// 走査の前に読んだ内容で上書きすると、走査中に追加された曲や変えられた名前が消えるので、保存する直前に読み直す
    /// 読み直しから保存までに await は無いので、その間に別の書き込みは入らない
    private func removeSongs(playlistId: PlaylistId, songIds: Set<SongId>) {
        guard let current = playlistRepository.findById(playlistId: playlistId) else {
            return
        }

        playlistRepository.update(playlistId: playlistId, name: current.name, songIds: current.songIds.filter { !songIds.contains($0) })
    }
}

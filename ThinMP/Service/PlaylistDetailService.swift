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

    /// 全プレイリストの曲をまとめて 1 回で取り、プレイリストごとに振り分ける
    /// SongRepository.findByIds はライブラリ全件を走査するので、プレイリストごとに呼ばない
    /// スキャンはバックグラウンドで行い、SwiftData の読み書きだけメインアクターに残す
    private func createModels(playlists: [PlaylistEntity]) async -> [PlaylistDetailModel] {
        let songIds = playlists.flatMap { $0.songIds }.uniqued()
        let librarySongs = await Task.detached(priority: .userInitiated) { [songRepository] in
            songRepository.findByIds(songIds: songIds)
        }.value
        let songById = librarySongs.keyed { $0.songId }

        return playlists.map { playlist in
            let songs = playlist.songIds.compactMap { songById[$0] }

            // 端末から削除された曲がプレイリストに残っている場合は取り除いて保存する
            if songs.count != playlist.songIds.count {
                playlistRepository.update(playlistId: playlist.playlistId, name: playlist.name, songIds: songs.map { $0.songId })
            }

            let artwork = songs.first { $0.artwork != nil }?.artwork

            return PlaylistDetailModel(playlistId: playlist.playlistId, primaryText: playlist.name, artwork: artwork, songs: songs)
        }
    }
}

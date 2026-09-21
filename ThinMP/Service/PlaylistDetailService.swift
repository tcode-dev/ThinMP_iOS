//
//  PlaylistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

struct PlaylistDetailService: PlaylistDetailServiceProtocol {
    private let playlistRepository: PlaylistRepositoryProtocol
    private let songRepository: SongRepositoryProtocol
    private let playlistRegister: PlaylistRegisterProtocol

    init(
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository(),
        songRepository: SongRepositoryProtocol = SongRepository(),
        playlistRegister: PlaylistRegisterProtocol = PlaylistRegister()
    ) {
        self.playlistRepository = playlistRepository
        self.songRepository = songRepository
        self.playlistRegister = playlistRegister
    }

    func findById(playlistId: PlaylistId) async -> PlaylistDetailModel {
        let playlist = playlistRepository.findById(playlistId: playlistId)

        return await createModels(playlists: [playlist])[0]
    }

    func findByIds(playlistIds: [PlaylistId]) async -> [PlaylistDetailModel] {
        let playlists = playlistRepository.findByIds(playlistIds: playlistIds)

        return await createModels(playlists: playlists)
    }

    /// 全プレイリストの曲をまとめて 1 回で取り、プレイリストごとに振り分ける
    /// SongRepository.findByIds はライブラリ全件を舐めるので、プレイリストごとに呼ばない
    /// スキャンはバックグラウンドで行い、SwiftData の読み書きだけメインアクターに残す
    private func createModels(playlists: [PlaylistEntity]) async -> [PlaylistDetailModel] {
        let songIds = playlists.flatMap { $0.songIds }.uniqued()
        let found = await Task.detached(priority: .userInitiated) { [songRepository] in
            songRepository.findByIds(songIds: songIds)
        }.value
        let songs = Dictionary(
            found.map { ($0.songId.id, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        return playlists.map { playlist in
            let found = playlist.songIds.compactMap { songs[$0.id] }

            // 端末から削除された曲がプレイリストに残っている場合は取り除いて保存する
            if found.count != playlist.songIds.count {
                playlistRegister.update(playlistId: playlist.playlistId, name: playlist.name, songIds: found.map { $0.songId })
            }

            let artwork = found.first { $0.artwork != nil }?.artwork

            return PlaylistDetailModel(playlistId: playlist.playlistId, primaryText: playlist.name, artwork: artwork, songs: found)
        }
    }
}

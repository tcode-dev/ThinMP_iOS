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
        let librarySongs = await Task.detached(priority: .userInitiated) { [songRepository] in
            songRepository.findByIds(songIds: songIds)
        }.value
        let songById = librarySongs.keyed { $0.songId }

        return playlists.map { playlist in
            let songs = playlist.songIds.compactMap { songById[$0] }

            // 端末から削除された曲がプレイリストに残っている場合は、その曲だけ取り除く
            if songs.count != playlist.songIds.count {
                removeSongs(playlistId: playlist.playlistId, songIds: Set(playlist.songIds.filter { songById[$0] == nil }))
            }

            let artwork = songs.first { $0.artwork != nil }?.artwork

            return PlaylistDetailModel(playlistId: playlist.playlistId, primaryText: playlist.name, artwork: artwork, songs: songs)
        }
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

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

    func findById(playlistId: PlaylistId) -> PlaylistDetailModel {
        let playlist = playlistRepository.findById(playlistId: playlistId)

        return createModel(playlist: playlist)
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel] {
        let playlists = playlistRepository.findByIds(playlistIds: playlistIds)

        return playlists.map { playlist in
            createModel(playlist: playlist)
        }
    }

    private func createModel(playlist: PlaylistEntity) -> PlaylistDetailModel {
        let songIds = playlist.songIds
        let songs = songRepository.findByIds(songIds: songIds)
        let sorted = songIds
            .filter { songId in songs.contains(where: { $0.songId.equals(songId) }) }
            .map { songId in songs.first { songId.equals($0.songId) }! }
        let artwork = sorted.first(where: { song -> Bool in
            song.artwork != nil
        })?.artwork

        // 端末から削除された曲がプレイリストに残っている場合は取り除いて読み直す
        if !validation(songIds: songIds, songs: songs) {
            fix(playlist: playlist, songs: songs)

            return createModel(playlist: playlistRepository.findById(playlistId: playlist.playlistId))
        }

        return PlaylistDetailModel(playlistId: playlist.playlistId, primaryText: playlist.name, artwork: artwork, songs: sorted)
    }

    private func validation(songIds: [SongId], songs: [SongModel]) -> Bool {
        return songIds.count == songs.count
    }

    private func fix(playlist: PlaylistEntity, songs: [SongModel]) {
        let songIds = songs.map { $0.songId }

        playlistRegister.update(playlistId: playlist.playlistId, name: playlist.name, songIds: songIds)
    }
}

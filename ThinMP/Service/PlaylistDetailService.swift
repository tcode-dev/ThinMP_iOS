//
//  PlaylistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

struct PlaylistDetailService {
    func findById(playlistId: PlaylistId) -> PlaylistDetailModel {
        let playlistRepository = PlaylistRepository()
        let playlist = playlistRepository.findById(playlistId: playlistId)

        return createModel(playlist: playlist)
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel] {
        let playlistRepository = PlaylistRepository()
        let playlists = playlistRepository.findByIds(playlistIds: playlistIds)

        return playlists.map { playlist in
            createModel(playlist: playlist)
        }
    }

    private func createModel(playlist: PlaylistRealmModel) -> PlaylistDetailModel {
        let playlistSongs = playlist.songs.sorted(byKeyPath: PlaylistSongRealmModel.ORDER)
        let songIds = Array(playlistSongs.map { SongId(id: UInt64($0.songId)!) })
        let repository = SongRepository()
        let songs = repository.findByIds(songIds: songIds)
        let sorted = songIds
            .filter { songId in songs.contains(where: { $0.songId.equals(songId) }) }
            .map { songId in songs.first { songId.equals($0.songId) }! }
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { song -> Bool in
            song.artwork != nil
        })?.artwork

        if !validation(songIds: songIds, songs: songs) {
            fix(playlist: playlist, songs: songs)

            return createModel(playlist: playlist)
        }

        return PlaylistDetailModel(playlistId: PlaylistId(id: playlist.id), primaryText: playlist.name, artwork: artwork, songs: arrayed)
    }

    private func validation(songIds: [SongId], songs: [SongModel]) -> Bool {
        return songIds.count == songs.count
    }

    private func fix(playlist: PlaylistRealmModel, songs: [SongModel]) {
        let playlistRegister = PlaylistRegister()
        let songIds = songs.map { $0.songId }

        playlistRegister.update(playlistId: PlaylistId(id: playlist.id), name: playlist.name, songIds: songIds)
    }
}

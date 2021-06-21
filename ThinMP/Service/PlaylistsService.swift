//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

import MediaPlayer

struct PlaylistsService {
    func findAll() -> [PlaylistModel] {
        let playlistRepository = PlaylistRepository()
        let playlists = playlistRepository.findAll()

        return playlists.map { playlist in
            return createModel(playlist: playlist)
        }
    }

    private func createModel(playlist: PlaylistRealmModel) -> PlaylistModel {
        let playlistSongs = playlist.songs.sorted(byKeyPath: PlaylistSongRealmModel.ORDER)
        let songIds = Array(playlistSongs.map { SongId(id: UInt64($0.songId)!)})
        let repository = SongRepository()
        let songs = repository.findByIds(songIds: songIds)
        let sorted = songIds.map{ (songId) in songs.first { songId.equals($0.songId) }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.artwork != nil)
        })?.artwork

        return PlaylistModel(playlistId: PlaylistId(id: playlist.id), primaryText: playlist.name, artwork: artwork)
    }
}

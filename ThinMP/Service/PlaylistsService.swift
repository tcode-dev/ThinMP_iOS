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
        let playlistSongs = playlist.songs.sorted(byKeyPath: "order")
        let persistentIds = Array(playlistSongs.map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID})
        let repository = SongRepository()
        let songs = repository.findByIds(persistentIds: persistentIds)
        let sorted = persistentIds.map{ (persistentId) in songs.first { $0.persistentId == persistentId }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.artwork != nil)
        })?.artwork

        return PlaylistModel(id: playlist.id, primaryText: playlist.name, artwork: artwork)
    }
}

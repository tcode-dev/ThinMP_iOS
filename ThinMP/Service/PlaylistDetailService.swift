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
            return createModel(playlist: playlist)
        }
    }

    private func createModel(playlist: PlaylistRealmModel) -> PlaylistDetailModel {
        let playlistSongs = playlist.songs.sorted(byKeyPath: "order")
        let persistentIds = Array(playlistSongs.map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID})
        let repository = SongRepository()
        let songs = repository.findByIds(persistentIds: persistentIds)
        let sorted = persistentIds.map{ (persistentId) in songs.first { $0.persistentId == persistentId }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.artwork != nil)
        })?.artwork

        return PlaylistDetailModel(playlistId: PlaylistId(id: playlist.id), primaryText: playlist.name, artwork: artwork, songs: arrayed)
    }
}

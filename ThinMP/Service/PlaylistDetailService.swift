//
//  PlaylistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import RealmSwift
import MediaPlayer

struct PlaylistDetailService {
    func findById(playlistId: String) -> PlaylistDetailModel {
        let playlistRepository = PlaylistRepository()
        let playlist = playlistRepository.findById(playlistId: playlistId)
        let playlistSongs = playlist.songs.sorted(byKeyPath: "order")
        let persistentIds = Array(playlistSongs.map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID})
        let repository = SongRepository()
        let songs = repository.findByIds(persistentIds: persistentIds)
        let sorted = persistentIds.map{ (persistentId) in songs.first { $0.persistentId == persistentId }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.artwork != nil)
        })?.artwork

        return PlaylistDetailModel(primaryText: playlist.name, artwork: artwork, list: arrayed)
    }
}

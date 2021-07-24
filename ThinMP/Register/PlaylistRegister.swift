//
//  PlaylistRegister.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import MediaPlayer

struct PlaylistRegister: PlaylistRegisterProtocol {
    let repository: PlaylistRepository

    init() {
        repository = PlaylistRepository()
    }

    func create(songId: SongId, name: String) {
        repository.create(songId: songId, name: name)
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        repository.add(playlistId: playlistId, songId: songId)
    }

    func update(playlistIds: [PlaylistId]) {
        repository.update(playlistIds: playlistIds)
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        repository.update(playlistId: playlistId, name: name, songIds: songIds)
    }

    func delete(playlistId: PlaylistId) {
        repository.delete(playlistId: playlistId)
    }
}

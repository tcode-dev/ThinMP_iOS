//
//  PlaylistRegister.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import MediaPlayer

struct PlaylistRegister {
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

    // プレイリスト一覧の更新
    func update(playlistIds: [PlaylistId]) {
        repository.update(playlistIds: playlistIds)
    }

    // プレイリスト詳細の更新
    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        repository.update(playlistId: playlistId, name: name, songIds: songIds)
    }

    func delete(playlistId: PlaylistId) {
        repository.delete(playlistId: playlistId)
    }
}

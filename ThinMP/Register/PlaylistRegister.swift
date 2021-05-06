//
//  PlaylistRegister.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import MediaPlayer

struct PlaylistRegister {
    var repository: PlaylistRepository

    init() {
        repository = PlaylistRepository()
    }

    func create(persistentId: MPMediaEntityPersistentID, name: String) {
        repository.create(persistentId: persistentId, name: name)
    }

    func add(playlistId: String, persistentId: MPMediaEntityPersistentID) {
        repository.add(playlistId: playlistId, persistentId: persistentId)
    }

    // プレイリスト一覧の更新
    func update(playlistIds: [String]) {
        repository.update(playlistIds: playlistIds)
    }

    // プレイリスト詳細の更新
    func update(playlistId: String, name: String, persistentIds: [MPMediaEntityPersistentID]) {
        repository.update(playlistId: playlistId, name: name, persistentIds: persistentIds)
    }

    func delete(playlistIds: [String]) {
        repository.delete(playlistIds: playlistIds)
    }
}

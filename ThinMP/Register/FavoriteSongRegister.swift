//
//  FavoriteSongRegister.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import MediaPlayer

struct FavoriteSongRegister {
    var repository: FavoriteSongRepository

    init() {
        repository = FavoriteSongRepository()
    }

    func add(persistentId: MPMediaEntityPersistentID) {
        repository.add(persistentId: persistentId)
    }

    func delete(persistentId: MPMediaEntityPersistentID) {
        repository.delete(persistentId: persistentId)
    }

    func update(persistentIdList: [MPMediaEntityPersistentID]) {
        repository.update(persistentIdList: persistentIdList)
    }

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return repository.exists(persistentId: persistentId)
    }
}

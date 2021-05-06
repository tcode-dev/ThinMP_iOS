//
//  FavoriteArtistRegister.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//

import MediaPlayer

struct FavoriteArtistRegister {
    var repository: FavoriteArtistRepository

    init() {
        repository = FavoriteArtistRepository()
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

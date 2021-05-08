//
//  ShortcutRegister.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import MediaPlayer

struct ShortcutRegister {
    var repository: ShortcutRepository

    init() {
        repository = ShortcutRepository()
    }

    func existsArtist(persistentId: MPMediaEntityPersistentID) -> Bool {
        return repository.existsArtist(itemId: persistentId)
    }

    func addArtist(persistentId: MPMediaEntityPersistentID) {
        repository.addArtist(itemId: persistentId)
    }

    func deleteArtist(persistentId: MPMediaEntityPersistentID) {
        repository.deleteArtist(itemId: persistentId)
    }
}

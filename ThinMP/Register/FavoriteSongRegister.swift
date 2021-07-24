//
//  FavoriteSongRegister.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import MediaPlayer

struct FavoriteSongRegister: FavoriteSongRegisterProtocol {
    let repository: FavoriteSongRepository

    init() {
        repository = FavoriteSongRepository()
    }

    func add(songId: SongId) {
        repository.add(songId: songId)
    }

    func exists(songId: SongId) -> Bool {
        return repository.exists(songId: songId)
    }

    func update(songIds: [SongId]) {
        repository.update(songIds: songIds)
    }

    func delete(songId: SongId) {
        repository.delete(songId: songId)
    }
}

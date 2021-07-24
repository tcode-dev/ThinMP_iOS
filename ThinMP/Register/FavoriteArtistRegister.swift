//
//  FavoriteArtistRegister.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//

import MediaPlayer

struct FavoriteArtistRegister: FavoriteArtistRegisterProtocol {
    let repository: FavoriteArtistRepository

    init() {
        repository = FavoriteArtistRepository()
    }

    func add(artistId: ArtistId) {
        repository.add(artistId: artistId)
    }

    func exists(artistId: ArtistId) -> Bool {
        return repository.exists(artistId: artistId)
    }

    func update(artistIds: [ArtistId]) {
        repository.update(artistIds: artistIds)
    }

    func delete(artistId: ArtistId) {
        repository.delete(artistId: artistId)
    }
}

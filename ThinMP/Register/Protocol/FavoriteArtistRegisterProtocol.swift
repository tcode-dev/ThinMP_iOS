//
//  FavoriteArtistRegisterProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol FavoriteArtistRegisterProtocol {
    func add(artistId: ArtistId)

    func exists(artistId: ArtistId) -> Bool

    func update(artistIds: [ArtistId])

    func delete(artistId: ArtistId)
}

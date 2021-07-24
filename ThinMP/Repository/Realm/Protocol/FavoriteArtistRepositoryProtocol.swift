//
//  FavoriteArtistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol FavoriteArtistRepositoryProtocol {
    func findAll() -> [ArtistId]

    func exists(artistId: ArtistId) -> Bool

    func add(artistId: ArtistId)

    func update(artistIds: [ArtistId])

    func delete(artistId: ArtistId)
}

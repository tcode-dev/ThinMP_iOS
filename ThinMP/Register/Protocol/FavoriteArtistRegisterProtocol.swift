//
//  FavoriteArtistRegisterProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

import Foundation

protocol FavoriteArtistRegisterProtocol {
    func add(artistId: ArtistId)

    func exists(artistId: ArtistId) -> Bool

    func update(artistIds: [ArtistId])

    func delete(artistId: ArtistId)
}

//
//  FavoriteArtistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol FavoriteArtistsServiceProtocol {
    func findAll() async -> [ArtistModel]
}

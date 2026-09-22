//
//  ArtistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ArtistDetailServiceProtocol {
    func findById(artistId: ArtistId) async -> ArtistDetailModel?

    func findByIds(artistIds: [ArtistId]) async -> [ArtistDetailModel]
}

//
//  ArtistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ArtistDetailServiceProtocol {
    func findById(artistId: ArtistId) -> ArtistDetailModel?

    func findByIds(artistIds: [ArtistId]) -> [ArtistDetailModel]
}

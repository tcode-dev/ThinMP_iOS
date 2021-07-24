//
//  ArtistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

import Foundation

protocol ArtistRepositoryProtocol {
    func findAll() -> [ArtistModel]

    func findById(artistId: ArtistId) -> ArtistModel?

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel]
}

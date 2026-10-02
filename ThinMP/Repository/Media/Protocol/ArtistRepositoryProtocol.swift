//
//  ArtistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol ArtistRepositoryProtocol: Sendable {
    func findAll() -> [ArtistModel]

    func findById(artistId: ArtistId) -> ArtistModel?

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel]
}

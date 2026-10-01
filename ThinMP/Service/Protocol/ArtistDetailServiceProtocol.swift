//
//  ArtistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol ArtistDetailServiceProtocol: Sendable {
    @concurrent
    func findById(artistId: ArtistId) async -> ArtistDetailModel?

    @concurrent
    func findByIds(artistIds: [ArtistId]) async -> [ArtistSummaryModel]
}

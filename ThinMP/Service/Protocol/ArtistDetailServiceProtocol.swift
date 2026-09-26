//
//  ArtistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol ArtistDetailServiceProtocol: Sendable {
    func findById(artistId: ArtistId) async -> ArtistDetailModel?

    func findByIds(artistIds: [ArtistId]) async -> [ArtistSummaryModel]

    /// ショートカット用。artistIds のうち、クラウドにしか無いアーティストも含めてライブラリに無いもの(ArtistRepositoryProtocol.findDeletedIds)
    func findDeletedIds(artistIds: [ArtistId]) async -> Set<ArtistId>
}

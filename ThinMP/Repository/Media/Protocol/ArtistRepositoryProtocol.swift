//
//  ArtistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ArtistRepositoryProtocol: Sendable {
    func findAll() -> [ArtistModel]

    func findById(artistId: ArtistId) -> ArtistModel?

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel]

    /// artistIds のうち、クラウドにしか無いアーティストも含めてライブラリに無いもの
    /// findByIds で見つからなかったアーティストをストアから消してよいかの判定に使う(SongRepositoryProtocol.findDeletedIds と同じ)
    func findDeletedIds(artistIds: [ArtistId]) -> Set<ArtistId>
}

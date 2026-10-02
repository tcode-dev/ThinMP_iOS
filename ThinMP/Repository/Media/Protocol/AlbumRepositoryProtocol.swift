//
//  AlbumRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol AlbumRepositoryProtocol: Sendable {
    func findAll() -> [AlbumModel]

    func findById(albumId: AlbumId) -> AlbumModel?

    func findByIds(albumIds: [AlbumId]) -> [AlbumModel]

    /// アルバム名順。predicate は曲に掛かるので、コンピレーション盤のように
    /// アーティストの曲を 1 曲でも含むアルバムは、代表アーティストが別でも含まれる
    func findByArtistId(artistId: ArtistId) -> [AlbumModel]

    func findRecently(count: Int) -> [AlbumModel]
}

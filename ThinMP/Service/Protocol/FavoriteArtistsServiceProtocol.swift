//
//  FavoriteArtistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol FavoriteArtistsServiceProtocol {
    func findAll() async -> [ArtistModel]

    func exists(artistId: ArtistId) -> Bool

    func add(artistId: ArtistId)

    func delete(artistId: ArtistId)

    /// 編集ページの並び順と削除を保存する
    func update(artistIds: [ArtistId])
}

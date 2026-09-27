//
//  FavoriteArtistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol FavoriteArtistRepositoryProtocol {
    func findAll() -> [ArtistId]

    func exists(artistId: ArtistId) -> Bool

    func add(artistId: ArtistId)

    func update(artistIds: [ArtistId])

    func delete(artistId: ArtistId)
}

extension FavoriteArtistRepositoryProtocol {
    /// 登録済みなら外し、未登録なら入れる。切り替えたあとの登録状態を返す
    @discardableResult
    func toggle(artistId: ArtistId) -> Bool {
        if exists(artistId: artistId) {
            delete(artistId: artistId)

            return false
        }

        add(artistId: artistId)

        return true
    }
}

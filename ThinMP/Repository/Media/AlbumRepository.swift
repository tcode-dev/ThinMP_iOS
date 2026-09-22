//
//  AlbumRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class AlbumRepository: AlbumRepositoryProtocol {
    func findAll() -> [AlbumModel] {
        return albums(localAlbumsQuery())
    }

    func findById(albumId: AlbumId) -> AlbumModel? {
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID))

        return albums(query).first
    }

    /// MPMediaQuery には IN 述語が無いので、ライブラリを 1 回取得して Set で絞る
    /// 結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    func findByIds(albumIds: [AlbumId]) -> [AlbumModel] {
        if albumIds.isEmpty {
            return []
        }

        let ids = Set(albumIds)
        let albums = Dictionary(
            albums(localAlbumsQuery())
                .filter { ids.contains($0.albumId) }
                .map { ($0.albumId, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        return albumIds.compactMap { albums[$0] }
    }

    func findByArtistId(artistId: ArtistId) -> [AlbumModel] {
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        return albums(query).sorted { ($0.primaryText ?? "") < ($1.primaryText ?? "") }
    }

    func findRecently(count: Int) -> [AlbumModel] {
        return collections(localAlbumsQuery())
            .sorted { ($0.representativeItem?.dateAdded ?? .distantPast) > ($1.representativeItem?.dateAdded ?? .distantPast) }
            .prefix(count)
            .compactMap { AlbumModel(collection: $0) }
    }

    /// クラウドにしか無い項目を除いた全アルバム
    private func localAlbumsQuery() -> MPMediaQuery {
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))

        return query
    }

    private func collections(_ query: MPMediaQuery) -> [MPMediaItemCollection] {
        return query.collections ?? []
    }

    private func albums(_ query: MPMediaQuery) -> [AlbumModel] {
        return collections(query).compactMap { AlbumModel(collection: $0) }
    }
}

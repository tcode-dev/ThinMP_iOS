//
//  AlbumRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

struct AlbumRepository: AlbumRepositoryProtocol {
    func findAll() -> [AlbumModel] {
        return albums(localAlbumsQuery())
    }

    func findById(albumId: AlbumId) -> AlbumModel? {
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID))

        return albums(query).first
    }

    /// 結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    func findByIds(albumIds: [AlbumId]) -> [AlbumModel] {
        if albumIds.isEmpty {
            return []
        }

        return albums(localAlbumsQuery()).reordered(by: albumIds) { $0.albumId }
    }

    func findByArtistId(artistId: ArtistId) -> [AlbumModel] {
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        return albums(query).sorted { ($0.primaryText ?? "") < ($1.primaryText ?? "") }
    }

    /// 追加が新しい順に count 件
    func findRecently(count: Int) -> [AlbumModel] {
        // MPMediaItem のプロパティ取得は安くないので、比較のたびに dateAdded を引かずに 1 回だけ取る
        let albums = collections(localAlbumsQuery()).compactMap { collection -> (album: AlbumModel, dateAdded: Date)? in
            guard let item = collection.representativeItem, let album = AlbumModel(collection: collection) else {
                return nil
            }

            return (album, item.dateAdded)
        }

        return albums.sorted { $0.dateAdded > $1.dateAdded }.prefix(count).map { $0.album }
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

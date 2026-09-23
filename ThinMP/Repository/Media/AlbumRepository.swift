//
//  AlbumRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

struct AlbumRepository: AlbumRepositoryProtocol {
    func findAll() -> [AlbumModel] {
        return albums(MPMediaQuery.albums().localItems())
    }

    func findById(albumId: AlbumId) -> AlbumModel? {
        let query = MPMediaQuery.albums().localItems()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID))

        return albums(query).first
    }

    /// 結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    func findByIds(albumIds: [AlbumId]) -> [AlbumModel] {
        if albumIds.isEmpty {
            return []
        }

        let albums = albums(MPMediaQuery.albums().localItems()).keyed { $0.albumId }

        return albumIds.compactMap { albums[$0] }
    }

    /// クラウドのアルバムも探すので localItems() を通さない
    func findDeletedIds(albumIds: [AlbumId]) -> Set<AlbumId> {
        if albumIds.isEmpty {
            return []
        }

        let libraryIds = Set(albums(MPMediaQuery.albums()).map { $0.albumId })

        return Set(albumIds).subtracting(libraryIds)
    }

    /// アーティストの曲を含むアルバム。コンピレーション盤も入る(AlbumRepositoryProtocol を参照)
    func findByArtistId(artistId: ArtistId) -> [AlbumModel] {
        let query = MPMediaQuery.albums().localItems()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        // < だと大文字小文字や全角半角、数字の桁で並びが崩れるので、Finder と同じ比較にする
        return albums(query).sorted { ($0.primaryText ?? "").localizedStandardCompare($1.primaryText ?? "") == .orderedAscending }
    }

    /// 追加が新しい順に count 件
    func findRecently(count: Int) -> [AlbumModel] {
        // MPMediaItem のプロパティ取得は安くないので、比較のたびに dateAdded を引かずに 1 回だけ取る
        let albums = (MPMediaQuery.albums().localItems().collections ?? []).compactMap { collection -> (album: AlbumModel, dateAdded: Date)? in
            guard let item = collection.representativeItem, let album = AlbumModel(collection: collection) else {
                return nil
            }

            return (album, item.dateAdded)
        }

        return albums.sorted { $0.dateAdded > $1.dateAdded }.prefix(count).map { $0.album }
    }

    private func albums(_ query: MPMediaQuery) -> [AlbumModel] {
        return (query.collections ?? []).compactMap { AlbumModel(collection: $0) }
    }
}

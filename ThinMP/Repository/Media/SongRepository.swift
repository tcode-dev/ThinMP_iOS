//
//  SongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class SongRepository: SongRepositoryProtocol {
    func findAll() -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map { SongModel(media: $0) }
    }

    /// MPMediaQuery には IN 述語が無いので、ライブラリを 1 回取得して Set で絞る
    /// 結果は songIds の順で、ライブラリに無い曲は落ちる
    func findByIds(songIds: [SongId]) -> [SongModel] {
        if songIds.isEmpty {
            return []
        }

        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()
        let ids = Set(songIds.map { $0.id })

        query.addFilterPredicate(property)

        let songs = Dictionary(
            query.collections!
                .filter { ids.contains($0.persistentID) }
                .map { ($0.persistentID, SongModel(media: $0)) },
            uniquingKeysWith: { first, _ in first }
        )

        return songIds.compactMap { songs[$0.id] }
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map { SongModel(media: $0) }
    }

    func findByAlbumIds(albumIds: [AlbumId]) -> [SongModel] {
        return Array(
            albumIds
                .map { findByAlbumId(albumId: $0) }
                .joined()
        )
    }
}

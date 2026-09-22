//
//  SongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class SongRepository: SongRepositoryProtocol {
    func findAll() -> [SongModel] {
        return songs(localSongsQuery())
    }

    /// MPMediaQuery には IN 述語が無いので、ライブラリを 1 回取得して Set で絞る
    /// 結果は songIds の順で、ライブラリに無い曲は落ちる
    func findByIds(songIds: [SongId]) -> [SongModel] {
        if songIds.isEmpty {
            return []
        }

        let ids = Set(songIds)
        let songs = Dictionary(
            songs(localSongsQuery())
                .filter { ids.contains($0.songId) }
                .map { ($0.songId, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        return songIds.compactMap { songs[$0] }
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID))

        return songs(query)
    }

    func findByAlbumIds(albumIds: [AlbumId]) -> [SongModel] {
        return albumIds.flatMap { findByAlbumId(albumId: $0) }
    }

    /// クラウドにしか無い項目を除いた全曲
    private func localSongsQuery() -> MPMediaQuery {
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))

        return query
    }

    private func songs(_ query: MPMediaQuery) -> [SongModel] {
        return (query.collections ?? []).map { SongModel(media: $0) }
    }
}

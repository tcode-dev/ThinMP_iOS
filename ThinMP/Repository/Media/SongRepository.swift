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

    /// 結果は songIds の順で、ライブラリに無い曲は落ちる
    func findByIds(songIds: [SongId]) -> [SongModel] {
        if songIds.isEmpty {
            return []
        }

        return songs(localSongsQuery()).reordered(by: songIds) { $0.songId }
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
        return (query.items ?? []).map { SongModel(item: $0) }
    }
}

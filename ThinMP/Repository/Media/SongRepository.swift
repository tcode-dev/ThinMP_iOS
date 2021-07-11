//
//  SongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class SongRepository {
    func findAll() -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map {SongModel(media: $0)}
    }

    func findByIds(songIds: [SongId]) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()
        let ids = songIds.map {$0.id}

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter {ids.contains($0.representativeItem?.persistentID ?? 0)}

        return songIds
            .filter {(songId) in filtered.contains(where: {$0.representativeItem?.persistentID == songId.id})}
            .map { (songId) in filtered.first { $0.representativeItem?.persistentID == songId.id }!}
            .map {SongModel(media: $0)}
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map {SongModel(media: $0)}
    }

    func findByAlbumIds(albumIds: [AlbumId]) -> [SongModel] {
        return Array(
            albumIds
                .map { findByAlbumId(albumId: $0)}
                .joined()
        )
    }
}

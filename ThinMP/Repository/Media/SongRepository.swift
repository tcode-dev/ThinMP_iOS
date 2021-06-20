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

        return query.collections!.map{SongModel(media: $0)}
    }

    func findByIds(songIds: [SongId]) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        let ids = songIds.map{$0.id}
        let filtered = query.collections!.filter{ids.contains($0.representativeItem?.persistentID ?? 0)}
        let sorted = songIds
            .map{ (songId) in filtered.first { $0.representativeItem?.persistentID == songId.id }!}
            .map{SongModel(media: $0)}

        return Array(sorted)
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map{SongModel(media: $0)}
    }

    func findByAlbumIds(albumIds: [AlbumId]) -> [SongModel] {
        return Array(
            albumIds
                .map { findByAlbumId(albumId: $0)}
                .joined()
        )
    }
}

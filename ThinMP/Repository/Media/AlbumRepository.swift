//
//  AlbumRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class AlbumRepository {
    func findAll() -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        let albums: [AlbumModel] = query.collections!.map{
            let item = $0.representativeItem

            return AlbumModel(persistentID: item?.albumPersistentID, title: item?.albumTitle, artist: item?.artist, artwork: item?.artwork)
        }

        return albums
    }

    func findById(persistentId: MPMediaEntityPersistentID) -> AlbumModel? {
        let property = MPMediaPropertyPredicate(value: persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return AlbumModel(persistentID: $0.representativeItem?.albumPersistentID, title: $0.representativeItem?.albumTitle, artist: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }.first
    }

    func findSongsById(persistentId: MPMediaEntityPersistentID) -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map{SongModel(media: $0)}
    }
}

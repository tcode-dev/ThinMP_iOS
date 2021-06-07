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

            return AlbumModel(persistentId: item?.albumPersistentID, primaryText: item?.albumTitle, secondaryText: item?.artist, artwork: item?.artwork)
        }

        return albums
    }

    func findById(persistentId: MPMediaEntityPersistentID) -> AlbumModel? {
        let property = MPMediaPropertyPredicate(value: persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return AlbumModel(persistentId: $0.representativeItem?.albumPersistentID, primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }.first
    }

    func findByIds(persistentIds: [MPMediaEntityPersistentID]) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter{persistentIds.contains($0.representativeItem?.albumPersistentID ?? 0)}
        let albums = filtered.map{
            return AlbumModel(persistentId: $0.representativeItem?.albumPersistentID, primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }

        return Array(albums)
    }

    func findByArtistId(persistentId: MPMediaEntityPersistentID) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.sorted(by: { String($0.representativeItem?.albumTitle ?? "") < String($1.representativeItem?.albumTitle ?? "") })
            .map{AlbumModel(persistentId: $0.representativeItem?.albumPersistentID, primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }
    }

    func findRecently(count: Int) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        let albums: [AlbumModel] = query.collections!.sorted(by: { l, r in
            return l.representativeItem!.dateAdded > r.representativeItem!.dateAdded
        })
        .prefix(count)
        .map {
            let item = $0.representativeItem

            return AlbumModel(persistentId: item?.albumPersistentID, primaryText: item?.albumTitle, secondaryText: item?.artist, artwork: item?.artwork)
        }

        return albums
    }
}

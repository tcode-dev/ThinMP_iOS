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

        return query.collections!.map {
            return AlbumModel(albumId: AlbumId(id: $0.representativeItem!.albumPersistentID), primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }
    }

    func findById(albumId: AlbumId) -> AlbumModel? {
        let property = MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.map {
            return AlbumModel(albumId: AlbumId(id: $0.representativeItem!.albumPersistentID), primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }.first
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()
        let ids = albumIds.map { $0.id }

        query.addFilterPredicate(property)

        return query.collections!.filter { ids.contains($0.representativeItem?.albumPersistentID ?? 0) }
            .map { AlbumModel(albumId: AlbumId(id: ($0.representativeItem?.albumPersistentID)!), primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork) }
    }

    func findByArtistId(artistId: ArtistId) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.sorted(by: { String($0.representativeItem?.albumTitle ?? "") < String($1.representativeItem?.albumTitle ?? "") })
            .map { AlbumModel(albumId: AlbumId(id: $0.representativeItem!.albumPersistentID), primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork) }
    }

    func findRecently(count: Int) -> [AlbumModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.sorted(by: { left, right in
            left.representativeItem!.dateAdded > right.representativeItem!.dateAdded
        })
        .prefix(count)
        .map { AlbumModel(albumId: AlbumId(id: $0.representativeItem!.albumPersistentID), primaryText: $0.representativeItem?.albumTitle, secondaryText: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork) }
    }
}

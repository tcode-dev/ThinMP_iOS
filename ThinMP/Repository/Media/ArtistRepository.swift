//
//  ArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class ArtistRepository {
    func findAll() -> [ArtistModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        let artists = Array(query.collections!.map{
            return ArtistModel(persistentId: $0.representativeItem?.artistPersistentID, primaryText: $0.representativeItem?.artist)
        })

        return artists
    }

    func findById(persistentId: MPMediaEntityPersistentID) -> ArtistModel? {
        let property = MPMediaPropertyPredicate(value: persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return ArtistModel(persistentId: $0.representativeItem?.artistPersistentID, primaryText: $0.representativeItem?.artist)
        }.first
    }

    func findByIds(persistentIds: [MPMediaEntityPersistentID]) -> [ArtistModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter{persistentIds.contains($0.representativeItem?.artistPersistentID ?? 0)}
        let sorted = persistentIds
            .map{ (persistentId) in filtered.first { $0.representativeItem?.artistPersistentID == persistentId }}
            .map{ ArtistModel(persistentId: $0?.representativeItem?.artistPersistentID, primaryText: $0?.representativeItem?.artist)}

        return Array(sorted)
    }
}

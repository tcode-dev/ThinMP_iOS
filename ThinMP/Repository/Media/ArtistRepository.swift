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
            return ArtistModel(artistId: ArtistId(id: $0.representativeItem!.artistPersistentID), primaryText: $0.representativeItem?.artist)
        })

        return artists
    }

    func findById(artistId: ArtistId) -> ArtistModel? {
        let property = MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return ArtistModel(artistId: ArtistId(id: $0.representativeItem!.artistPersistentID), primaryText: $0.representativeItem?.artist)
        }.first
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        let ids = artistIds.map{$0.id}
        let filtered = query.collections!.filter{ids.contains($0.representativeItem?.artistPersistentID ?? 0)}
        let sorted = artistIds
            .map{ (artistId) in filtered.first { $0.representativeItem?.artistPersistentID == artistId.id }}
            .map{ ArtistModel(artistId: ArtistId(id: ($0?.representativeItem!.artistPersistentID)!), primaryText: $0?.representativeItem?.artist)}

        return Array(sorted)
    }
}

//
//  ArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

class ArtistRepository: ArtistRepositoryProtocol {
    func findAll() -> [ArtistModel] {
        return artists(localArtistsQuery())
    }

    func findById(artistId: ArtistId) -> ArtistModel? {
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        return artists(query).first
    }

    /// 結果は artistIds の順で、ライブラリに無いアーティストは落ちる
    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        if artistIds.isEmpty {
            return []
        }

        return artists(localArtistsQuery()).reordered(by: artistIds) { $0.artistId }
    }

    /// クラウドにしか無い項目を除いた全アーティスト
    private func localArtistsQuery() -> MPMediaQuery {
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))

        return query
    }

    private func artists(_ query: MPMediaQuery) -> [ArtistModel] {
        return (query.collections ?? []).compactMap { ArtistModel(collection: $0) }
    }
}

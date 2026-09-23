//
//  ArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

struct ArtistRepository: ArtistRepositoryProtocol {
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

        let artists = artists(localArtistsQuery()).keyed { $0.artistId }

        return artistIds.compactMap { artists[$0] }
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

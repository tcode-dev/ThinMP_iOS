//
//  ArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

struct ArtistRepository: ArtistRepositoryProtocol {
    func findAll() -> [ArtistModel] {
        return artists(MPMediaQuery.artists().localItems())
    }

    func findById(artistId: ArtistId) -> ArtistModel? {
        let query = MPMediaQuery.artists().localItems()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        return artists(query).first
    }

    /// 結果は artistIds の順で、ライブラリに無いアーティストは落ちる
    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        if artistIds.isEmpty {
            return []
        }

        let artists = artists(MPMediaQuery.artists().localItems()).keyed { $0.artistId }

        return artistIds.compactMap { artists[$0] }
    }

    /// クラウドのアーティストも探すので localItems() を通さない
    func findDeletedIds(artistIds: [ArtistId]) -> Set<ArtistId> {
        if artistIds.isEmpty {
            return []
        }

        let libraryIds = Set(artists(MPMediaQuery.artists()).map { $0.artistId })

        return Set(artistIds).subtracting(libraryIds)
    }

    private func artists(_ query: MPMediaQuery) -> [ArtistModel] {
        return (query.collections ?? []).compactMap { ArtistModel(collection: $0) }
    }
}

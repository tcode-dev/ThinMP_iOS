//
//  SongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/05.
//

import MediaPlayer

struct SongRepository: SongRepositoryProtocol {
    func findAll() -> [SongModel] {
        return songs(MPMediaQuery.songs().localItems())
    }

    /// 結果は songIds の順で、ライブラリに無い曲は落ちる
    func findByIds(songIds: [SongId]) -> [SongModel] {
        if songIds.isEmpty {
            return []
        }

        let songs = songs(MPMediaQuery.songs().localItems()).keyed { $0.songId }

        return songIds.compactMap { songs[$0] }
    }

    /// songs() のクエリは曲名順に並ぶので、トラック順に並べ直す
    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        let query = MPMediaQuery.songs().localItems()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: albumId.id, forProperty: MPMediaItemPropertyAlbumPersistentID))

        return songs(query).sortedByTrack()
    }

    /// アーティストの曲を 1 回のクエリで引く。アルバムごとの並びは呼び出し側で揃える
    /// トラック順に並べておくので、呼び出し側がアルバムごとに振り分ければアルバムの中はトラック順になる
    func findByArtistId(artistId: ArtistId) -> [SongModel] {
        let query = MPMediaQuery.songs().localItems()

        query.addFilterPredicate(MPMediaPropertyPredicate(value: artistId.id, forProperty: MPMediaItemPropertyArtistPersistentID))

        return songs(query).sortedByTrack()
    }

    private func songs(_ query: MPMediaQuery) -> [SongModel] {
        return (query.items ?? []).map { SongModel(item: $0) }
    }
}

//
//  SongRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol SongRepositoryProtocol {
    func findAll() -> [SongModel]

    func findByIds(songIds: [SongId]) -> [SongModel]

    func findByAlbumId(albumId: AlbumId) -> [SongModel]

    /// アーティスト自身の曲。コンピレーション盤にある他のアーティストの曲は含まない
    func findByArtistId(artistId: ArtistId) -> [SongModel]
}

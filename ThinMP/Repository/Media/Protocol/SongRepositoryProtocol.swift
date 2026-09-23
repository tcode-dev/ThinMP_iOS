//
//  SongRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol SongRepositoryProtocol {
    func findAll() -> [SongModel]

    func findByIds(songIds: [SongId]) -> [SongModel]

    /// 曲名順。トラック順ではなく曲名順にするのは意図どおり
    func findByAlbumId(albumId: AlbumId) -> [SongModel]

    /// アーティスト自身の曲。コンピレーション盤にある他のアーティストの曲は含まない
    /// 曲名順(findByAlbumId と同じく、トラック順ではない)
    func findByArtistId(artistId: ArtistId) -> [SongModel]
}

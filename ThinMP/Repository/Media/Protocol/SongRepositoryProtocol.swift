//
//  SongRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol SongRepositoryProtocol {
    func findAll() -> [SongModel]

    func findByIds(songIds: [SongId]) -> [SongModel]

    /// トラック順(ディスク番号、トラック番号の順)
    func findByAlbumId(albumId: AlbumId) -> [SongModel]

    /// アーティスト自身の曲。コンピレーション盤にある他のアーティストの曲は含まない
    /// トラック順なので、アルバムごとに振り分けるとアルバムの中はトラック順になる
    func findByArtistId(artistId: ArtistId) -> [SongModel]
}

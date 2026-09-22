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

    func findByArtistId(artistId: ArtistId) -> [SongModel]
}

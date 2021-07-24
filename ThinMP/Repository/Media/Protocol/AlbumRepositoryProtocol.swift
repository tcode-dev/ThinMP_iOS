//
//  AlbumRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

import Foundation

protocol AlbumRepositoryProtocol {
    func findAll() -> [AlbumModel]

    func findById(albumId: AlbumId) -> AlbumModel?

    func findByIds(albumIds: [AlbumId]) -> [AlbumModel]

    func findByArtistId(artistId: ArtistId) -> [AlbumModel]

    func findRecently(count: Int) -> [AlbumModel]
}

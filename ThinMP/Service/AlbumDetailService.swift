//
//  AlbumDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailService: AlbumDetailServiceProtocol {
    private let albumRepository: AlbumRepositoryProtocol
    private let songRepository: SongRepositoryProtocol

    init(
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        songRepository: SongRepositoryProtocol = SongRepository()
    ) {
        self.albumRepository = albumRepository
        self.songRepository = songRepository
    }

    func findById(albumId: AlbumId) -> AlbumDetailModel? {
        let album = albumRepository.findById(albumId: albumId)
        let songs = songRepository.findByAlbumId(albumId: albumId)

        if let album = album {
            return AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: songs)
        }

        return Optional.none
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        let albums = albumRepository.findByIds(albumIds: albumIds)

        return albums.map { album in
            AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: [])
        }
    }
}

//
//  AlbumDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailService {
    func findById(albumId: AlbumId) -> AlbumDetailModel? {
        let albumRepository = AlbumRepository()
        let songRepository = SongRepository()
        let album = albumRepository.findById(albumId: albumId)
        let songs = songRepository.findByAlbumId(albumId: albumId)

        if let album = album {
            return AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: songs)
        }

        return Optional.none
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        let repository = AlbumRepository()
        let albums = repository.findByIds(albumIds: albumIds)

        return albums.map { album in
            AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: [])
        }
    }
}

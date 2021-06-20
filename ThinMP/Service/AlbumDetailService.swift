//
//  AlbumDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailService {
    func findById(albumId: AlbumId) -> AlbumDetailModel {
        let albumRepository = AlbumRepository()
        let songRepository = SongRepository()
        let album = albumRepository.findById(albumId: albumId)
        let songs = songRepository.findByAlbumId(albumId: albumId)

        return AlbumDetailModel(albumId: album!.albumId, primaryText: album?.primaryText, secondaryText: album?.secondaryText, artwork: album?.artwork, songs: songs)
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        let repository = AlbumRepository()
        let albums = repository.findByIds(albumIds: albumIds)

        return albums.map { album in
            return AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: [])
        }
    }
}

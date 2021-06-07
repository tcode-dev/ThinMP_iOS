//
//  AlbumDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailService {
    func findById(persistentId: MPMediaEntityPersistentID) -> AlbumDetailModel {
        let albumRepository = AlbumRepository()
        let songRepository = SongRepository()
        let album = albumRepository.findById(persistentId: persistentId)
        let songs = songRepository.findByAlbumId(persistentId: persistentId)

        return AlbumDetailModel(persistentId: album?.persistentId, primaryText: album?.primaryText, secondaryText: album?.secondaryText, artwork: album?.artwork, songs: songs)
    }

    func findByIds(persistentIds: [MPMediaEntityPersistentID]) -> [AlbumDetailModel] {
        let repository = AlbumRepository()
        let albums = repository.findByIds(persistentIds: persistentIds)

        return albums.map { album in
            return AlbumDetailModel(persistentId: album.persistentId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: [])
        }
    }
}

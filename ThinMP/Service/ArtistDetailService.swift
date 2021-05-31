//
//  ArtistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailService {
    func findById(persistentId: MPMediaEntityPersistentID) -> ArtistDetailModel {
        let repository = ArtistRepository()
        let artist = repository.findById(persistentId: persistentId)
        let primaryText  = artist?.primaryText
        let albums = repository.findAlbumsById(persistentId: persistentId)
        let artwork = albums.first(where: { (album) -> Bool in
            (album.artwork != nil)
        })?.artwork
        let songs = repository.findSongsById(persistentId: persistentId)
        let secondaryText = "\(albums.count) albums, \(songs.count) songs"

        return ArtistDetailModel(primaryText: primaryText, secondaryText: secondaryText, artwork: artwork, albums: albums, songs: songs)
    }
}

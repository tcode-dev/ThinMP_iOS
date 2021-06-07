//
//  ArtistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailService {
    func findById(persistentId: MPMediaEntityPersistentID) -> ArtistDetailModel {
        let artistRepository = ArtistRepository()
        let albumRepository = AlbumRepository()
        let songRepository = SongRepository()
        let artist = artistRepository.findById(persistentId: persistentId)
        let primaryText  = artist?.primaryText
        let albums = albumRepository.findByArtistId(persistentId: persistentId)
        let albumIds = albums.map{$0.persistentId!}
        let artwork = albums.first(where: { (album) -> Bool in
            (album.artwork != nil)
        })?.artwork
        let songs = songRepository.findByAlbumIds(persistentIds: albumIds)
        let secondaryText = "\(albums.count) albums, \(songs.count) songs"

        return ArtistDetailModel(persistentId: artist?.persistentId, primaryText: primaryText, secondaryText: secondaryText, artwork: artwork, albums: albums, songs: songs)
    }

    func findByIds(persistentIds: [MPMediaEntityPersistentID]) -> [ArtistDetailModel] {
        let artistRepository = ArtistRepository()
        let albumRepository = AlbumRepository()
        let artists = artistRepository.findByIds(persistentIds: persistentIds)

        return artists.map { artist in
            let albums = albumRepository.findByArtistId(persistentId: artist.persistentId)
            let artwork = albums.first(where: { (album) -> Bool in
                (album.artwork != nil)
            })?.artwork

            return ArtistDetailModel(persistentId: artist.persistentId, primaryText: artist.primaryText, secondaryText: artist.secondaryText, artwork: artwork, albums: [], songs: [])
        }
    }
}

//
//  ArtistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailService: ArtistDetailServiceProtocol {
    func findById(artistId: ArtistId) -> ArtistDetailModel? {
        let artistRepository = ArtistRepository()
        let albumRepository = AlbumRepository()
        let songRepository = SongRepository()
        let artist = artistRepository.findById(artistId: artistId)
        let primaryText = artist?.primaryText
        let albums = albumRepository.findByArtistId(artistId: artistId)
        let albumIds = albums.map { $0.albumId }
        let artwork = albums.first(where: { album -> Bool in
            album.artwork != nil
        })?.artwork
        let songs = songRepository.findByAlbumIds(albumIds: albumIds)
        let secondaryText = "\(albums.count) albums, \(songs.count) songs"

        if let artist = artist {
            return ArtistDetailModel(artistId: artist.artistId, primaryText: primaryText, secondaryText: secondaryText, artwork: artwork, albums: albums, songs: songs)
        }

        return Optional.none
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistDetailModel] {
        let artistRepository = ArtistRepository()
        let albumRepository = AlbumRepository()
        let artists = artistRepository.findByIds(artistIds: artistIds)

        return artists.map { artist in
            let albums = albumRepository.findByArtistId(artistId: artist.artistId)
            let artwork = albums.first(where: { album -> Bool in
                album.artwork != nil
            })?.artwork

            return ArtistDetailModel(artistId: artist.artistId, primaryText: artist.primaryText, secondaryText: artist.secondaryText, artwork: artwork, albums: [], songs: [])
        }
    }
}

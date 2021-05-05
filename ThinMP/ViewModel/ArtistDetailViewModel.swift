//
//  ArtistDetail.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import MediaPlayer

class ArtistDetailViewModel: ObservableObject {
    @Published var persistentId: MPMediaEntityPersistentID!
    @Published var name: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var albums: [Album] = []
    @Published var songs: [SongModel] = []
    @Published var albumCount: Int = 0
    @Published var songCount: Int = 0
    @Published var meta: String?

    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        if MPMediaLibrary.authorizationStatus() == .authorized {
            fetch()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.fetch()
                }
            }
        }
    }

    func fetch() {
        if let artist = getArtist() {
            self.name = artist.primaryText
        }

        let albums = getAlbums()

        if !albums.isEmpty {
            self.albums = albums
            self.albumCount = albums.count
            self.artwork = self.albums.first(where: { (album) -> Bool in
                (album.artwork != nil)
            })?.artwork
        }

        self.songs = getSongs()
        self.songCount = self.songs.count

        self.meta = "\(self.albumCount) albums, \(self.songCount) songs"
    }

    func getArtist() -> ArtistModel? {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return ArtistModel(persistentId: $0.representativeItem?.artistPersistentID, primaryText: $0.representativeItem?.artist)
        }.first
    }

    func getAlbums() -> [Album] {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        return query.collections!.map{
            return Album(persistentID: $0.representativeItem?.albumPersistentID, title: $0.representativeItem?.albumTitle, artist: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }
    }

    func getSongs() -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        return query.collections!.map{SongModel(media: $0)}
    }
}

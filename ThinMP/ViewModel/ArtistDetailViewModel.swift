//
//  ArtistDetail.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import MediaPlayer

class ArtistDetailViewModel: ObservableObject {
    private var persistentId: MPMediaEntityPersistentID!
    @Published var name: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var albums: [Album] = []
    @Published var songs: [Song] = []
    @Published var songCollections: [MPMediaItemCollection] = []
    @Published var albumCount: Int = 0
    @Published var songCount: Int = 0
    
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
            self.name = artist.name
        }
        
        let albums = getAlbums()

        if !albums.isEmpty {
            self.albums = albums
            self.albumCount = albums.count
            self.artwork = self.albums.first(where: { (album) -> Bool in
                (album.artwork != nil)
            })?.artwork
        }

        let songs = getSongs()

        if !songs.songs.isEmpty && !songs.songCollections.isEmpty {
            self.songs = songs.songs
            self.songCount = songs.songs.count
            self.songCollections = songs.songCollections
        }
    }
    
    func getArtist() -> Artist? {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()
        
        query.addFilterPredicate(property)
        
        return query.collections!.map{
            return Artist(persistentId: $0.representativeItem?.artistPersistentID, name: $0.representativeItem?.artist)
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
    
    func getSongs() -> (songs: [Song], songCollections: [MPMediaItemCollection]) {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.songs()
        
        query.addFilterPredicate(property)
        
        let songCollections = query.collections!
        let songs = songCollections.map{
            return Song(title: $0.representativeItem?.title, artist: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }
        
        return (songs, songCollections);
    }
}

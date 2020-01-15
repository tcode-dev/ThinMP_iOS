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
    @Published var mediaItems: [MPMediaItem] = []
    @Published var albumCount: Int = 0
    @Published var songCount: Int = 0
    
    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        
        self.set()
    }
    
    func set() {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(property)
        self.mediaItems = query.items!
        let albumMap = Dictionary.init(grouping: self.mediaItems) { song -> MPMediaEntityPersistentID in
            return song.albumPersistentID
        }
        
        self.albums = albumMap.map {
            let (persistentID, songs) = $0
            let title = songs.first(where: { (song) -> Bool in
                (song.albumTitle != nil)
            })?.title
            let artist = songs.first(where: { (song) -> Bool in
                (song.albumArtist != nil)
            })?.artist
            let artwork = songs.first(where: { (song) -> Bool in
                (song.artwork != nil)
            })?.artwork
            
            return Album(persistentID: persistentID, title: title, artist: artist, artwork: artwork)
        }
        self.albumCount = self.albums.count
        
        self.songs = mediaItems.map {
            return Song(title: $0.title, artist: $0.artist, artwork: $0.artwork)
        }
        self.songCount = self.songs.count
        
        self.albums.sort(by: {$0.title! < $1.title! })
        
        self.name = self.albums.first(where: { (album) -> Bool in
            (album.artist != nil)
        })?.artist
        
        self.artwork = self.albums.first(where: { (album) -> Bool in
            (album.artwork != nil)
        })?.artwork
    }
}

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
        
        self.albums = albumMap.enumerated().map {
            let (persistentID, songs) = $0.element
            let title = songs.first(where: { (song) -> Bool in
                (song.albumTitle != nil)
            })?.title
            let artist = songs.first(where: { (song) -> Bool in
                (song.albumArtist != nil)
            })?.artist
            let artwork = songs.first(where: { (song) -> Bool in
                (song.artwork != nil)
            })?.artwork
            
            return Album(id: $0.offset, persistentID: persistentID, title: title, artist: artist, artwork: artwork)
        }
        self.albumCount = self.albums.count
        
        self.songs = mediaItems.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            
            return Song(id: offset, title: item.title, artist: item.artist, artwork: item.artwork)
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

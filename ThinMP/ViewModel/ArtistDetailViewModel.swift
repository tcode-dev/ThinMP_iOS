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
    @Published var songs: [MPMediaItem] = []
    
    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        
        self.set()
    }
    
    func set() {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(property)
        self.songs = query.items!
        let albumMap = Dictionary.init(grouping: self.songs) { song -> MPMediaEntityPersistentID in
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
        
        self.albums.sort(by: {$0.title! < $1.title! })
        
        self.name = self.albums.first(where: { (album) -> Bool in
            (album.artist != nil)
        })?.artist
        
        self.artwork = self.albums.first(where: { (album) -> Bool in
            (album.artwork != nil)
        })?.artwork
    }
    
    func getName() -> String? {
        return self.name
    }
    func getArtwork() -> MPMediaItemArtwork? {
        return self.artwork
    }
    func getAlbums() -> [Album] {
        return self.albums
    }
    func getSongs() -> [MPMediaItem] {
        return self.songs
    }
}

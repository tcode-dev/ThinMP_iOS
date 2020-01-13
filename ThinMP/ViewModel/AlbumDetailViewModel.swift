//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    private var persistentId: MPMediaEntityPersistentID!
    @Published var title: String?
    @Published var artist: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [Song] = []
    @Published var songCollections:[MPMediaItemCollection] = []
    
    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        
        self.set()
    }
    
    func set() {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(property)
        let albums = query.items!.filter({$0.albumTitle != nil})
        songCollections = query.collections!
        
        if (albums.count) > 0 {
            let album = albums[0]
            self.title = album.albumTitle
            self.artist = album.albumArtist
            self.artwork = album.artwork
        }
        songs = songCollections.enumerated().map{
            let offset = $0.offset
            let item = $0.element.representativeItem
            
            return Song(id: offset, title: item?.title, artist: item?.artist, artwork: item?.artwork)
        }
    }
}

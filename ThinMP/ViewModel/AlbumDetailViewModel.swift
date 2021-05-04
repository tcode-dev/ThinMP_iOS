//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    @Published var persistentId: MPMediaEntityPersistentID
    @Published var title: String?
    @Published var artist: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []
    
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
        if let album = getAlbum() {
            self.title = album.title
            self.artist = album.artist
            self.artwork = album.artwork
        }
        
        self.songs = fetchSongs()
    }
    
    func getAlbum() -> Album? {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()
        
        query.addFilterPredicate(property)
        
        return query.collections!.map{
            return Album(persistentID: $0.representativeItem?.albumPersistentID, title: $0.representativeItem?.albumTitle, artist: $0.representativeItem?.artist, artwork: $0.representativeItem?.artwork)
        }.first
    }
    
    func fetchSongs() -> [SongModel] {
        let property = MPMediaPropertyPredicate(value: self.persistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()
        
        query.addFilterPredicate(property)

        return query.collections!.map{SongModel(media: $0)}
    }
}

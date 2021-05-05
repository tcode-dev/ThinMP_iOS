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
        let repository = AlbumRepository()

        if let album = repository.findById(persistentId: persistentId) {
            self.title = album.title
            self.artist = album.artist
            self.artwork = album.artwork
        }
        
        self.songs = repository.findSongsById(persistentId: persistentId)
    }
}

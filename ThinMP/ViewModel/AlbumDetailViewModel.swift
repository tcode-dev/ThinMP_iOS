//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class AlbumDetailViewModel: ObservableObject {
    @Published var persistentId: MPMediaEntityPersistentID
    @Published var primaryText: String?
    @Published var secondaryText: String?
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
            self.primaryText = album.primaryText
            self.secondaryText = album.secondaryText
            self.artwork = album.artwork
        }
        
        self.songs = repository.findSongsById(persistentId: persistentId)
    }
}

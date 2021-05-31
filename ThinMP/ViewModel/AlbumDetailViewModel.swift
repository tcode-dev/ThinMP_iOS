//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class AlbumDetailViewModel: ViewModelProtocol {
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []

    private var persistentId: MPMediaEntityPersistentID!

    func load(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
        self.load()
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

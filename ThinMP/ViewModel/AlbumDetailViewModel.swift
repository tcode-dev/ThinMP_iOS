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
        let albumDetailService = AlbumDetailService()
        let albumDetailModel = albumDetailService.findById(persistentId: persistentId)

        DispatchQueue.main.async {
            self.primaryText = albumDetailModel.primaryText
            self.secondaryText = albumDetailModel.secondaryText
            self.artwork = albumDetailModel.artwork
            self.songs = albumDetailModel.songs
        }
    }
}

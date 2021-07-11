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

    private var albumId: AlbumId!

    func load(albumId: AlbumId) {
        self.albumId = albumId
        load()
    }

    func fetch() {
        let albumDetailService = AlbumDetailService()
        let albumDetailModel = albumDetailService.findById(albumId: albumId)

        DispatchQueue.main.async {
            if let albumDetailModel = albumDetailModel {
                self.primaryText = albumDetailModel.primaryText
                self.secondaryText = albumDetailModel.secondaryText
                self.artwork = albumDetailModel.artwork
                self.songs = albumDetailModel.songs
            }
        }
    }
}

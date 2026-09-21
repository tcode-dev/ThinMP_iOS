//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

@MainActor
class AlbumDetailViewModel: ObservableObject {
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []

    private var albumId: AlbumId!

    func load(albumId: AlbumId) {
        self.albumId = albumId

        Task {
            let albumDetailModel = await Task.detached(priority: .userInitiated) {
                AlbumDetailService().findById(albumId: albumId)
            }.value

            guard let albumDetailModel = albumDetailModel else { return }

            primaryText = albumDetailModel.primaryText
            secondaryText = albumDetailModel.secondaryText
            artwork = albumDetailModel.artwork
            songs = albumDetailModel.songs
        }
    }
}

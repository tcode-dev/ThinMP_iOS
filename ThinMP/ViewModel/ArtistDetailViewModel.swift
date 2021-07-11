//
//  ArtistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import MediaPlayer

class ArtistDetailViewModel: ViewModelProtocol {
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var albums: [AlbumModel] = []
    @Published var songs: [SongModel] = []

    private var artistId: ArtistId!

    func load(artistId: ArtistId) {
        self.artistId = artistId
        load()
    }

    func fetch() {
        let artistDetailService = ArtistDetailService()
        let artistDetailModel = artistDetailService.findById(artistId: artistId)

        DispatchQueue.main.async {
            if let artistDetailModel = artistDetailModel {
                self.primaryText = artistDetailModel.primaryText
                self.secondaryText = artistDetailModel.secondaryText
                self.artwork = artistDetailModel.artwork
                self.albums = artistDetailModel.albums
                self.songs = artistDetailModel.songs
            }
        }
    }
}

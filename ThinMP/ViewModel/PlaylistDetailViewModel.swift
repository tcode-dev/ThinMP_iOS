//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import MediaPlayer

class PlaylistDetailViewModel: ViewModelProtocol {
    @Published var primaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []

    var playlistId: String!

    func load(playlistId: String) {
        self.playlistId = playlistId
        self.load()
    }

    func fetch() {
        let playlistDetailService = PlaylistDetailService()
        let playlistDetailModel = playlistDetailService.findById(playlistId: playlistId)

        DispatchQueue.main.async {
            self.primaryText = playlistDetailModel.primaryText
            self.artwork = playlistDetailModel.artwork
            self.songs = playlistDetailModel.songs
        }
    }
}

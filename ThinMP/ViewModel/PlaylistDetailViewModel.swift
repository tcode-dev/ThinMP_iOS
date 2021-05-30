//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import RealmSwift
import MediaPlayer

class PlaylistDetailViewModel: ViewModelProtocol {
    @Published var primaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var list: [SongModel] = []

    let playlistId: String

    init(playlistId: String) {
        self.playlistId = playlistId
    }

    func fetch() {
        let playlistDetailService = PlaylistDetailService()
        let playlistDetailModel = playlistDetailService.findById(playlistId: playlistId)

        DispatchQueue.main.async {
            self.primaryText = playlistDetailModel.primaryText
            self.artwork = playlistDetailModel.artwork
            self.list = playlistDetailModel.list
        }
    }
}

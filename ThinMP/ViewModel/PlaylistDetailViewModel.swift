//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import MediaPlayer

@MainActor
class PlaylistDetailViewModel: ObservableObject {
    @Published var primaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []

    var playlistId: PlaylistId!

    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()) {
        self.playlistDetailService = playlistDetailService
    }

    @discardableResult
    func load(playlistId: PlaylistId) -> Task<Void, Never> {
        self.playlistId = playlistId

        return Task {
            let playlistDetailModel = await playlistDetailService.findById(playlistId: playlistId)

            primaryText = playlistDetailModel.primaryText
            artwork = playlistDetailModel.artwork
            songs = playlistDetailModel.songs
        }
    }
}

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

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    func load(playlistId: PlaylistId) {
        self.playlistId = playlistId

        Task {
            let playlistDetailModel = PlaylistDetailService().findById(playlistId: playlistId)

            primaryText = playlistDetailModel.primaryText
            artwork = playlistDetailModel.artwork
            songs = playlistDetailModel.songs
        }
    }
}

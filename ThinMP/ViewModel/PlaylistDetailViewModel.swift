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

    private let playlistDetailService: PlaylistDetailServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()) {
        self.playlistDetailService = playlistDetailService
    }

    @discardableResult
    func load(playlistId: PlaylistId) -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let playlistDetailModel = await playlistDetailService.findById(playlistId: playlistId)

            if Task.isCancelled { return }
            guard let playlistDetailModel = playlistDetailModel else { return }

            primaryText = playlistDetailModel.primaryText
            artwork = playlistDetailModel.artwork
            songs = playlistDetailModel.songs
        }

        loadTask = task

        return task
    }
}

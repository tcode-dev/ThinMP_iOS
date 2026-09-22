//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import Combine

@MainActor
class PlaylistDetailViewModel: ObservableObject {
    /// 読み込む前、または削除済みだったときは nil のまま。編集ページは songs を直接並べ替える
    @Published var playlist: PlaylistDetailModel?

    private let playlistDetailService: PlaylistDetailServiceProtocol
    private let playlistRepository: PlaylistRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService(),
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository()
    ) {
        self.playlistDetailService = playlistDetailService
        self.playlistRepository = playlistRepository
    }

    @discardableResult
    func load(playlistId: PlaylistId) -> Task<Void, Never> {
        return loadTask.run { [playlistDetailService] in
            await playlistDetailService.findById(playlistId: playlistId)
        } apply: { [weak self] playlist in
            if let playlist {
                self?.playlist = playlist
            }
        }
    }

    /// 編集ページの名前、並び順、削除を保存する
    func save(playlistId: PlaylistId, name: String) {
        playlistRepository.update(playlistId: playlistId, name: name, songIds: (playlist?.songs ?? []).map { $0.songId })
    }
}

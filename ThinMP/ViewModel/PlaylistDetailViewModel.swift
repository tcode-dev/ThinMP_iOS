//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import Combine

@MainActor
final class PlaylistDetailViewModel: ObservableObject {
    /// 読み込む前は nil。編集ページは songs を直接並べ替える
    /// 読み直して削除済みだったときは前の値を残す。画面が一瞬空になるのを避けるため
    @Published var playlist: PlaylistDetailModel?
    /// 1 回目の読み込みが終わったか。終わるまでは編集ページの保存を受け付けない
    @Published private(set) var isLoaded = false

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

            self?.isLoaded = true
        }
    }

    /// 編集ページの名前、並び順、削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の songs で上書きするとプレイリストの曲が全部消える)
    func save(playlistId: PlaylistId, name: String) {
        guard isLoaded else {
            return
        }

        playlistRepository.update(playlistId: playlistId, name: name, songIds: (playlist?.songs ?? []).map { $0.songId })
    }
}

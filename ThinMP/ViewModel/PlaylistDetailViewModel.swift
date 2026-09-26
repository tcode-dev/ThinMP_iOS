//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import Observation

@Observable
final class PlaylistDetailViewModel {
    /// 読み込む前と、削除済みで見つからなかったときは nil。編集ページは nil のあいだ保存を受け付けない
    /// 読み直して削除済みだったときは前の値を残す。画面が一瞬空になるのを避けるため
    /// 編集ページは songs を直接並べ替える
    var playlist: PlaylistDetailModel?

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
    /// 読み込み前に呼ばれたら何もしない(空の曲で上書きするとプレイリストの曲が全部消える)
    func save(name: String) {
        guard let playlist else {
            return
        }

        playlistRepository.update(playlistId: playlist.playlistId, name: name, songIds: playlist.songs.map { $0.songId })
    }
}

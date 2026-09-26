//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import Observation

@Observable
final class PlaylistsViewModel {
    /// 読み込む前は nil。編集ページは nil のあいだ保存を受け付けない
    var playlists: [PlaylistModel]?

    private let playlistsService: PlaylistsServiceProtocol
    private let playlistRepository: PlaylistRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        playlistsService: PlaylistsServiceProtocol = PlaylistsService(),
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository()
    ) {
        self.playlistsService = playlistsService
        self.playlistRepository = playlistRepository
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [playlistsService] in
            await playlistsService.findAll()
        } apply: { [weak self] playlists in
            self?.playlists = playlists
        }
    }

    /// 編集ページの並び順と削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の一覧で上書きするとプレイリストが全部消える)
    func save() {
        guard let playlists else {
            return
        }

        playlistRepository.update(playlistIds: playlists.map { $0.playlistId })
    }

    /// 一覧のコンテキストメニューから削除して読み直す
    func delete(playlistId: PlaylistId) {
        playlistRepository.delete(playlistId: playlistId)
        load()
    }
}

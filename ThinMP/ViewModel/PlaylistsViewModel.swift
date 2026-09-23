//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import Combine

@MainActor
final class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []
    /// 1 回目の読み込みが終わったか。終わるまでは編集ページの保存を受け付けない
    @Published private(set) var isLoaded = false

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
            self?.isLoaded = true
        }
    }

    /// 編集ページの並び順と削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の playlists で上書きするとプレイリストが全部消える)
    func save() {
        guard isLoaded else {
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

//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import Combine

@MainActor
class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []
    /// 登録モーダルで対象の曲がすでに入っているプレイリストの id
    @Published var registeredPlaylistIds: Set<String> = []

    private let playlistsService: PlaylistsServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(playlistsService: PlaylistsServiceProtocol = PlaylistsService()) {
        self.playlistsService = playlistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let playlists = await playlistsService.findAll()

            if Task.isCancelled { return }

            self.playlists = playlists
        }

        loadTask = task

        return task
    }

    /// 登録モーダル用。一覧を 1 回読み、そこから songId がすでに登録されているプレイリストを求める
    @discardableResult
    func load(songId: SongId) -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let playlists = await playlistsService.findAll()

            if Task.isCancelled { return }

            self.playlists = playlists
            registeredPlaylistIds = Set(playlists.filter { $0.contains(songId: songId) }.map { $0.id })
        }

        loadTask = task

        return task
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId.id)
    }
}

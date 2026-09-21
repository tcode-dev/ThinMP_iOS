//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import MediaPlayer

@MainActor
class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []
    /// 登録モーダルで対象の曲がすでに入っているプレイリストの id
    @Published var registeredPlaylistIds: Set<String> = []

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    func load() {
        Task {
            playlists = PlaylistsService().findAll()
        }
    }

    /// 登録モーダル用。一覧を 1 回読み、そこから songId がすでに登録されているプレイリストを求める
    func load(songId: SongId) {
        Task {
            playlists = PlaylistsService().findAll()
            registeredPlaylistIds = Set(playlists.filter { $0.contains(songId: songId) }.map { $0.id })
        }
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId.id)
    }
}

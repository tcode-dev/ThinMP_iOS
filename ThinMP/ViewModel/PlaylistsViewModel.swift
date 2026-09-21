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

    /// 一覧に加えて songId がすでに登録されているプレイリストも読み込む(登録モーダル用)
    func load(songId: SongId) {
        Task {
            let service = PlaylistsService()

            playlists = service.findAll()
            registeredPlaylistIds = Set(service.findRegisteredIds(songId: songId).map { $0.id })
        }
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId.id)
    }
}

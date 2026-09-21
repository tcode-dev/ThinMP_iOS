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

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    func load() {
        Task {
            playlists = PlaylistsService().findAll()
        }
    }
}

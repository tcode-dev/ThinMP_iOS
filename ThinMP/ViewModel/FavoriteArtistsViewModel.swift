//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import MediaPlayer

@MainActor
class FavoriteArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    func load() {
        Task {
            artists = FavoriteArtistsService().findAll()
        }
    }
}

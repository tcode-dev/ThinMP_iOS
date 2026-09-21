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

    private let favoriteArtistsService: FavoriteArtistsServiceProtocol

    init(favoriteArtistsService: FavoriteArtistsServiceProtocol = FavoriteArtistsService()) {
        self.favoriteArtistsService = favoriteArtistsService
    }

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            artists = favoriteArtistsService.findAll()
        }
    }
}

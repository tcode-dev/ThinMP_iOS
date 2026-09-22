//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import Combine

@MainActor
class FavoriteArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    private let favoriteArtistsService: FavoriteArtistsServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(favoriteArtistsService: FavoriteArtistsServiceProtocol = FavoriteArtistsService()) {
        self.favoriteArtistsService = favoriteArtistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let artists = await favoriteArtistsService.findAll()

            if Task.isCancelled { return }

            self.artists = artists
        }

        loadTask = task

        return task
    }
}

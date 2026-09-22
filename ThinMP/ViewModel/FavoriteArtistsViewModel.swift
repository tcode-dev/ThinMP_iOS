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
    private let loadTask = LoadTask()

    init(favoriteArtistsService: FavoriteArtistsServiceProtocol = FavoriteArtistsService()) {
        self.favoriteArtistsService = favoriteArtistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [favoriteArtistsService] in
            await favoriteArtistsService.findAll()
        } apply: { [weak self] artists in
            self?.artists = artists
        }
    }

    /// 編集ページの並び順と削除を保存する
    func save() {
        favoriteArtistsService.update(artistIds: artists.map { $0.artistId })
    }
}

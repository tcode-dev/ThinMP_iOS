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

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            artists = await favoriteArtistsService.findAll()
        }
    }
}

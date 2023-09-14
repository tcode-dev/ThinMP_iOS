//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import MediaPlayer

class FavoriteArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    func load() {
        let favoriteArtistsService = FavoriteArtistsService()
        let artists = favoriteArtistsService.findAll()

        DispatchQueue.main.async {
            self.artists = artists
        }
    }
}

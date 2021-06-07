//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import MediaPlayer

class FavoriteArtistsViewModel: ViewModelProtocol {
    @Published var artists: [ArtistModel] = []

    func fetch() {
        let favoriteArtistsService = FavoriteArtistsService()
        let artists = favoriteArtistsService.findAll()

        DispatchQueue.main.async {
            self.artists = artists
        }
    }
}

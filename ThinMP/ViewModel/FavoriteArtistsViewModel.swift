//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import RealmSwift
import MediaPlayer

class FavoriteArtistsViewModel: ViewModelProtocol {
    @Published var artists: [ArtistModel] = []

    func fetch() {
        let favoriteArtistRepository = FavoriteArtistRepository()
        let persistentIds = favoriteArtistRepository.findAll()
        let artistRepository = ArtistRepository()
        let artists = artistRepository.findByIds(persistentIds: persistentIds)

        DispatchQueue.main.async {
            self.artists = artists
        }
    }
}

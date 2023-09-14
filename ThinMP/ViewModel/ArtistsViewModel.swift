//
//  ArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

class ArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    func load() {
        let artistsService = ArtistsService()
        let artists = artistsService.findAll()

        DispatchQueue.main.async {
            self.artists = artists
        }
    }
}

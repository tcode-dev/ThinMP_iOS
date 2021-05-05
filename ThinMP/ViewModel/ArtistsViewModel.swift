//
//  Artists.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

class ArtistsViewModel: ViewModelProtocol {
    @Published var list: [ArtistModel] = []

    func fetch() {
        let repository = ArtistRepository()
        let artists = repository.findAll()

        DispatchQueue.main.async {
            self.list = artists
        }
    }
}

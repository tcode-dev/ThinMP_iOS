//
//  FavoriteSongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import MediaPlayer

class FavoriteSongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    func load() {
        let favoriteSongsService = FavoriteSongsService()
        let songs = favoriteSongsService.findAll()

        DispatchQueue.main.async {
            self.songs = songs
        }
    }
}

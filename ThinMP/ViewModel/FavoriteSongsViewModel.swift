//
//  FavoriteSongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import RealmSwift
import MediaPlayer

class FavoriteSongsViewModel: ViewModelProtocol {
    @Published var songs: [SongModel] = []

    func fetch() {
        let favoriteSongRepository = FavoriteSongRepository()
        let persistentIds = favoriteSongRepository.findAll()
        let songRepository = SongRepository()
        let songs = songRepository.findByIds(persistentIds: persistentIds)

        DispatchQueue.main.async {
            self.songs = songs
        }
    }
}

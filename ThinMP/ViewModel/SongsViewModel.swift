//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class SongsViewModel: ViewModelProtocol {
    @Published var songs: [SongModel] = []

    func fetch() {
        let repository = SongRepository()
        let songs = repository.findAll()

        DispatchQueue.main.async {
            self.songs = songs
        }
    }
}

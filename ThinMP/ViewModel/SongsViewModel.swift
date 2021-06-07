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
        let songsService = SongsService()
        let songs = songsService.findAll()

        DispatchQueue.main.async {
            self.songs = songs
        }
    }
}

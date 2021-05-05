//
//  PlaylistViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import RealmSwift
import MediaPlayer

class PlaylistViewModel: ViewModelProtocol {
    @Published var list: [PlaylistModel] = []

    func fetch() {
        let playlistRepository = PlaylistRepository()
        let playlists = playlistRepository.findAll()

        DispatchQueue.main.async {
            self.list = playlists
        }
    }
}


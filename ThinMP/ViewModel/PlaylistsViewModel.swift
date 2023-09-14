//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import MediaPlayer

class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []

    func load() {
        let playlistsService = PlaylistsService()
        let playlists = playlistsService.findAll()

        DispatchQueue.main.async {
            self.playlists = playlists
        }
    }
}

//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

class AlbumsViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []

    func load() {
        let albumsService = AlbumsService()
        let albums: [AlbumModel] = albumsService.findAll()

        DispatchQueue.main.async {
            self.albums = albums
        }
    }
}

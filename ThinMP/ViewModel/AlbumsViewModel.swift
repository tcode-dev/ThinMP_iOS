//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

class AlbumsViewModel: ViewModelProtocol {
    @Published var albums: [AlbumModel] = []

    func fetch() {
        let albumsService = AlbumsService()
        let albums: [AlbumModel] = albumsService.findAll()

        DispatchQueue.main.async {
            self.albums = albums
        }
    }
}

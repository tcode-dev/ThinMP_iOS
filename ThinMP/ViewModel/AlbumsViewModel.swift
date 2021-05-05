//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

class AlbumsViewModel: ViewModelProtocol {
    @Published var list: [AlbumModel] = []

    func fetch() {
        let repository = AlbumRepository()
        let albums: [AlbumModel] = repository.findAll()

        DispatchQueue.main.async {
            self.list = albums
        }
    }
}

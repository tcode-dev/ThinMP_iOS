//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MainViewModel: ViewModelProtocol {
    private let COUNT = 20

    @Published var list: [AlbumModel] = []

    func fetch() {
        let repository = AlbumRepository()
        let albums: [AlbumModel] = repository.findRecently(count: COUNT)

        DispatchQueue.main.async {
            self.list = albums
        }
    }
}

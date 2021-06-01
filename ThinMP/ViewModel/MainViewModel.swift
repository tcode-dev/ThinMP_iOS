//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MainViewModel: ViewModelProtocol {
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    func fetch() {
        let mainService = MainService()
        let shortcuts = mainService.findShortcuts()
        let albums = mainService.findRecentlyAlbums()

        DispatchQueue.main.async {
            self.shortcuts = shortcuts
            self.albums = albums
        }
    }
}

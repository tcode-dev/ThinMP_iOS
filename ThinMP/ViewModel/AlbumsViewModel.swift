//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import Observation

@Observable
final class AlbumsViewModel {
    private(set) var albums: [AlbumModel] = []

    private let albumsService: AlbumsServiceProtocol
    private let loadTask = LoadTask()

    init(albumsService: AlbumsServiceProtocol = AlbumsService()) {
        self.albumsService = albumsService
    }

    func load() async {
        await loadTask.run {
            await albumsService.findAll()
        } apply: { albums in
            self.albums = albums
        }
    }
}

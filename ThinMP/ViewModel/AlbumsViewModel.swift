//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import Combine

@MainActor
final class AlbumsViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []

    private let albumsService: AlbumsServiceProtocol
    private let loadTask = LoadTask()

    init(albumsService: AlbumsServiceProtocol = AlbumsService()) {
        self.albumsService = albumsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [albumsService] in
            await albumsService.findAll()
        } apply: { [weak self] albums in
            self?.albums = albums
        }
    }
}

//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

@MainActor
class AlbumsViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []

    private let albumsService: AlbumsServiceProtocol

    init(albumsService: AlbumsServiceProtocol = AlbumsService()) {
        self.albumsService = albumsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            albums = await Task.detached(priority: .userInitiated) { [albumsService] in
                albumsService.findAll()
            }.value
        }
    }
}

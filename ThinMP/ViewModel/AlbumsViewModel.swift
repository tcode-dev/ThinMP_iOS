//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import Combine

@MainActor
class AlbumsViewModel: ObservableObject {
    @Published var albums: [AlbumModel] = []

    private let albumsService: AlbumsServiceProtocol
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(albumsService: AlbumsServiceProtocol = AlbumsService()) {
        self.albumsService = albumsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let albums = await Task.detached(priority: .userInitiated) { [albumsService] in
                albumsService.findAll()
            }.value

            if Task.isCancelled { return }

            self.albums = albums
        }

        loadTask = task

        return task
    }
}

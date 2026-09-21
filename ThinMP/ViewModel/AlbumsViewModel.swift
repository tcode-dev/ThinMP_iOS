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

    func load() {
        Task {
            albums = await Task.detached(priority: .userInitiated) {
                AlbumsService().findAll()
            }.value
        }
    }
}

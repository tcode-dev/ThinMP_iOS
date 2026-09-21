//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

@MainActor
class SongsViewModel: ObservableObject {
    @Published var songs: [SongModel] = []

    func load() {
        Task {
            songs = await Task.detached(priority: .userInitiated) {
                SongsService().findAll()
            }.value
        }
    }
}

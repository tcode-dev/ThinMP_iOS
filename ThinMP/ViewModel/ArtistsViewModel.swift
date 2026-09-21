//
//  ArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

@MainActor
class ArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    func load() {
        Task {
            artists = await Task.detached(priority: .userInitiated) {
                ArtistsService().findAll()
            }.value
        }
    }
}

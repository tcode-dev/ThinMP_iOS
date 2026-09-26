//
//  ArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import Observation

@Observable
final class ArtistsViewModel {
    private(set) var artists: [ArtistModel] = []

    private let artistsService: ArtistsServiceProtocol
    private let loadTask = LoadTask()

    init(artistsService: ArtistsServiceProtocol = ArtistsService()) {
        self.artistsService = artistsService
    }

    func load() async {
        await loadTask.run {
            await artistsService.findAll()
        } apply: { artists in
            self.artists = artists
        }
    }
}

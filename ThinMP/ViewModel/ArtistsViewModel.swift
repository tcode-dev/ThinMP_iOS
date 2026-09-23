//
//  ArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import Combine

@MainActor
final class ArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []

    private let artistsService: ArtistsServiceProtocol
    private let loadTask = LoadTask()

    init(artistsService: ArtistsServiceProtocol = ArtistsService()) {
        self.artistsService = artistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [artistsService] in
            await artistsService.findAll()
        } apply: { [weak self] artists in
            self?.artists = artists
        }
    }
}

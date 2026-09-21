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

    private let artistsService: ArtistsServiceProtocol

    init(artistsService: ArtistsServiceProtocol = ArtistsService()) {
        self.artistsService = artistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            artists = await Task.detached(priority: .userInitiated) { [artistsService] in
                artistsService.findAll()
            }.value
        }
    }
}

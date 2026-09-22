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
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(artistsService: ArtistsServiceProtocol = ArtistsService()) {
        self.artistsService = artistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let artists = await Task.detached(priority: .userInitiated) { [artistsService] in
                artistsService.findAll()
            }.value

            if Task.isCancelled { return }

            self.artists = artists
        }

        loadTask = task

        return task
    }
}

//
//  ArtistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import Combine

@MainActor
class ArtistDetailViewModel: ObservableObject {
    /// 読み込む前、または見つからなかったときは nil のまま
    @Published var artist: ArtistDetailModel?

    private let artistDetailService: ArtistDetailServiceProtocol
    private let loadTask = LoadTask()

    init(artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService()) {
        self.artistDetailService = artistDetailService
    }

    @discardableResult
    func load(artistId: ArtistId) -> Task<Void, Never> {
        return loadTask.run { [artistDetailService] in
            await Task.detached(priority: .userInitiated) { artistDetailService.findById(artistId: artistId) }.value
        } apply: { [weak self] artist in
            if let artist {
                self?.artist = artist
            }
        }
    }
}

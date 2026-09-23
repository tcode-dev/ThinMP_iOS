//
//  ArtistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import Combine

@MainActor
final class ArtistDetailViewModel: ObservableObject {
    /// 読み込む前は nil
    /// 読み直して見つからなくなったときは前の値を残す。画面が一瞬空になるのを避けるため
    @Published private(set) var artist: ArtistDetailModel?

    private let artistDetailService: ArtistDetailServiceProtocol
    private let loadTask = LoadTask()

    init(artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService()) {
        self.artistDetailService = artistDetailService
    }

    @discardableResult
    func load(artistId: ArtistId) -> Task<Void, Never> {
        return loadTask.run { [artistDetailService] in
            await artistDetailService.findById(artistId: artistId)
        } apply: { [weak self] artist in
            if let artist {
                self?.artist = artist
            }
        }
    }
}

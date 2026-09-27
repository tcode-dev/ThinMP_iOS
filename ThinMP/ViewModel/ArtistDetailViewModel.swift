//
//  ArtistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import Observation

@Observable
final class ArtistDetailViewModel {
    /// 読み込む前は nil
    /// 読み直して見つからなくなったときは前の値を残す。画面が一瞬空になるのを避けるため
    private(set) var artist: ArtistDetailModel?

    private let artistDetailService: ArtistDetailServiceProtocol
    private let loadTask = LoadTask()

    init(artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService()) {
        self.artistDetailService = artistDetailService
    }

    func load(artistId: ArtistId) async {
        await loadTask.run {
            await artistDetailService.findById(artistId: artistId)
        } apply: { artist in
            if let artist {
                self.artist = artist
            }
        }
    }
}

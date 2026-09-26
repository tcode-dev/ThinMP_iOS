//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import Observation

@Observable
final class AlbumDetailViewModel {
    /// 読み込む前は nil
    /// 読み直して見つからなくなったときは前の値を残す。画面が一瞬空になるのを避けるため
    private(set) var album: AlbumDetailModel?

    private let albumDetailService: AlbumDetailServiceProtocol
    private let loadTask = LoadTask()

    init(albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService()) {
        self.albumDetailService = albumDetailService
    }

    func load(albumId: AlbumId) async {
        await loadTask.run {
            await albumDetailService.findById(albumId: albumId)
        } apply: { album in
            if let album {
                self.album = album
            }
        }
    }
}

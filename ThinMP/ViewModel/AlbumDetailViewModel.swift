//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import Combine

@MainActor
class AlbumDetailViewModel: ObservableObject {
    /// 読み込む前は nil
    /// 読み直して見つからなくなったときは前の値を残す。画面が一瞬空になるのを避けるため
    @Published var album: AlbumDetailModel?

    private let albumDetailService: AlbumDetailServiceProtocol
    private let loadTask = LoadTask()

    init(albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService()) {
        self.albumDetailService = albumDetailService
    }

    @discardableResult
    func load(albumId: AlbumId) -> Task<Void, Never> {
        return loadTask.run { [albumDetailService] in
            await albumDetailService.findById(albumId: albumId)
        } apply: { [weak self] album in
            if let album {
                self?.album = album
            }
        }
    }
}

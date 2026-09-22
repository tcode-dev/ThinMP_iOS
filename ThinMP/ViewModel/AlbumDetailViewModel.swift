//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import Combine

@MainActor
class AlbumDetailViewModel: ObservableObject {
    /// 読み込む前、または見つからなかったときは nil のまま
    @Published var album: AlbumDetailModel?

    private let albumDetailService: AlbumDetailServiceProtocol
    private let loadTask = LoadTask()

    init(albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService()) {
        self.albumDetailService = albumDetailService
    }

    @discardableResult
    func load(albumId: AlbumId) -> Task<Void, Never> {
        return loadTask.run { [albumDetailService] in
            await Task.detached(priority: .userInitiated) { albumDetailService.findById(albumId: albumId) }.value
        } apply: { [weak self] album in
            if let album {
                self?.album = album
            }
        }
    }
}

//
//  AlbumDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

@MainActor
class AlbumDetailViewModel: ObservableObject {
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var songs: [SongModel] = []

    private var albumId: AlbumId!
    private let albumDetailService: AlbumDetailServiceProtocol

    init(albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService()) {
        self.albumDetailService = albumDetailService
    }

    @discardableResult
    func load(albumId: AlbumId) -> Task<Void, Never> {
        self.albumId = albumId

        return Task {
            let albumDetailModel = await Task.detached(priority: .userInitiated) { [albumDetailService] in
                albumDetailService.findById(albumId: albumId)
            }.value

            guard let albumDetailModel = albumDetailModel else { return }

            primaryText = albumDetailModel.primaryText
            secondaryText = albumDetailModel.secondaryText
            artwork = albumDetailModel.artwork
            songs = albumDetailModel.songs
        }
    }
}

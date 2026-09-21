//
//  ArtistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/08.
//

import MediaPlayer

@MainActor
class ArtistDetailViewModel: ObservableObject {
    @Published var primaryText: String?
    @Published var secondaryText: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var albums: [AlbumModel] = []
    @Published var songs: [SongModel] = []

    private var artistId: ArtistId!
    private let artistDetailService: ArtistDetailServiceProtocol

    init(artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService()) {
        self.artistDetailService = artistDetailService
    }

    @discardableResult
    func load(artistId: ArtistId) -> Task<Void, Never> {
        self.artistId = artistId

        return Task {
            let artistDetailModel = await Task.detached(priority: .userInitiated) { [artistDetailService] in
                artistDetailService.findById(artistId: artistId)
            }.value

            guard let artistDetailModel = artistDetailModel else { return }

            primaryText = artistDetailModel.primaryText
            secondaryText = artistDetailModel.secondaryText
            artwork = artistDetailModel.artwork
            albums = artistDetailModel.albums
            songs = artistDetailModel.songs
        }
    }
}

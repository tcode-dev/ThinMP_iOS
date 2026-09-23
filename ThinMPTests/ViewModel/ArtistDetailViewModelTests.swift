//
//  ArtistDetailViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct ArtistDetailViewModelTests {
    private let artistId = ArtistId(id: 10)

    private func makeService() -> ArtistDetailServiceMock {
        return ArtistDetailServiceMock(artists: [
            ArtistDetailModel(
                artistId: artistId,
                primaryText: "Artist",
                artwork: nil,
                albums: [AlbumModel(albumId: AlbumId(id: 1), primaryText: "Album", secondaryText: nil, artwork: nil)],
                songs: [.fake(id: 1), .fake(id: 2)]
            ),
        ])
    }

    @Test
    func loadPublishesArtistDetail() async {
        let vm = ArtistDetailViewModel(artistDetailService: makeService())

        await vm.load(artistId: artistId).value

        #expect(vm.artist?.primaryText == "Artist")
        #expect(vm.artist?.albums.map { $0.albumId.id } == [1])
        #expect(vm.artist?.songs.map { $0.songId.id } == [1, 2])
    }

    @Test
    func loadKeepsStateWhenArtistIsMissing() async {
        let vm = ArtistDetailViewModel(artistDetailService: makeService())

        await vm.load(artistId: ArtistId(id: 99)).value

        #expect(vm.artist == nil)
    }
}

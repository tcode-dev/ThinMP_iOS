//
//  ListViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

/// Service に委譲するだけの一覧 ViewModel。SongsViewModel は SongsViewModelTests を参照
@MainActor
struct AlbumsViewModelTests {
    @Test
    func loadPublishesAlbumsFromService() async {
        let service = AlbumsServiceMock(albums: [
            AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: nil, artwork: nil),
            AlbumModel(albumId: AlbumId(id: 2), primaryText: "B", secondaryText: nil, artwork: nil),
        ])
        let vm = AlbumsViewModel(albumsService: service)

        await vm.load().value

        #expect(vm.albums.map { $0.albumId.id } == [1, 2])
        #expect(service.findAllCalls == 1)
    }
}

@MainActor
struct ArtistsViewModelTests {
    @Test
    func loadPublishesArtistsFromService() async {
        let service = ArtistsServiceMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
        ])
        let vm = ArtistsViewModel(artistsService: service)

        await vm.load().value

        #expect(vm.artists.map { $0.artistId.id } == [1, 2])
        #expect(service.findAllCalls == 1)
    }
}

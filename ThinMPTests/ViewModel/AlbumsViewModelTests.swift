//
//  AlbumsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct AlbumsViewModelTests {
    @Test
    func loadPublishesAlbumsFromService() async {
        let service = AlbumsServiceMock(albums: [
            AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: nil, artwork: nil),
            AlbumModel(albumId: AlbumId(id: 2), primaryText: "B", secondaryText: nil, artwork: nil),
        ])
        let vm = AlbumsViewModel(albumsService: service)

        await vm.load()

        #expect(vm.albums.map { $0.albumId.id } == [1, 2])
        #expect(service.findAllCalls == 1)
    }
}

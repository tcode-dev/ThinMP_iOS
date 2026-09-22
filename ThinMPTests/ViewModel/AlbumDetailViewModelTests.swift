//
//  AlbumDetailViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct AlbumDetailViewModelTests {
    @Test
    func loadPublishesAlbumDetail() async {
        let album = AlbumDetailModel(albumId: AlbumId(id: 10), primaryText: "Album", secondaryText: "Artist", artwork: nil, songs: [.fake(id: 1)])
        let vm = AlbumDetailViewModel(albumDetailService: AlbumDetailServiceMock(albums: [album]))

        await vm.load(albumId: AlbumId(id: 10)).value

        #expect(vm.primaryText == "Album")
        #expect(vm.secondaryText == "Artist")
        #expect(vm.songs.map { $0.songId.id } == [1])
    }

    @Test
    func loadKeepsStateWhenAlbumIsMissing() async {
        let vm = AlbumDetailViewModel(albumDetailService: AlbumDetailServiceMock(albums: []))

        await vm.load(albumId: AlbumId(id: 99)).value

        #expect(vm.primaryText == nil)
        #expect(vm.songs.isEmpty)
    }
}

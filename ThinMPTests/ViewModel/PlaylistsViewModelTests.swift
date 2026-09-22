//
//  PlaylistsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct PlaylistsViewModelTests {
    private func makeService() -> PlaylistsServiceMock {
        return PlaylistsServiceMock(playlists: [
            PlaylistModel(playlistId: PlaylistId(id: "a"), primaryText: "A", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistModel(playlistId: PlaylistId(id: "b"), primaryText: "B", songIds: [SongId(id: 3)]),
        ])
    }

    @Test
    func loadPublishesPlaylists() async {
        let vm = PlaylistsViewModel(playlistsService: makeService())

        await vm.load().value

        #expect(vm.playlists.map { $0.id } == ["a", "b"])
        #expect(vm.registeredPlaylistIds.isEmpty)
    }

    @Test
    func loadWithSongIdMarksPlaylistsContainingIt() async {
        let service = makeService()
        let vm = PlaylistsViewModel(playlistsService: service)

        await vm.load(songId: SongId(id: 2)).value

        #expect(vm.registeredPlaylistIds == ["a"])
        #expect(vm.isRegistered(playlistId: PlaylistId(id: "a")))
        #expect(!vm.isRegistered(playlistId: PlaylistId(id: "b")))
        #expect(service.findAllCalls == 1)
    }
}

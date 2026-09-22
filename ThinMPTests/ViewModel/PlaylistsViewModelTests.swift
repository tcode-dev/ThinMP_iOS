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

        #expect(vm.registeredPlaylistIds == [PlaylistId(id: "a")])
        #expect(vm.isRegistered(playlistId: PlaylistId(id: "a")))
        #expect(!vm.isRegistered(playlistId: PlaylistId(id: "b")))
        #expect(service.findAllCalls == 1)
    }

    @Test
    func saveWritesEditedOrder() async {
        let service = makeService()
        let vm = PlaylistsViewModel(playlistsService: service)

        await vm.load().value
        vm.playlists.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(service.updateCalls == [[PlaylistId(id: "b"), PlaylistId(id: "a")]])
    }

    @Test
    func createAndAddGoThroughTheService() {
        let service = makeService()
        let vm = PlaylistsViewModel(playlistsService: service)

        vm.create(songId: SongId(id: 5), name: "New")
        vm.add(playlistId: PlaylistId(id: "a"), songId: SongId(id: 6))

        #expect(service.createCalls.count == 1)
        #expect(service.createCalls[0].name == "New")
        #expect(service.createCalls[0].songId == SongId(id: 5))
        #expect(service.addCalls.count == 1)
        #expect(service.addCalls[0].playlistId == PlaylistId(id: "a"))
        #expect(service.addCalls[0].songId == SongId(id: 6))
    }

    @Test
    func deleteRemovesThenReloads() async {
        let service = makeService()
        let vm = PlaylistsViewModel(playlistsService: service)

        await vm.load().value
        vm.delete(playlistId: PlaylistId(id: "a"))
        await Task.yield()

        #expect(service.deleteCalls == [PlaylistId(id: "a")])
        #expect(service.findAllCalls == 2)
    }
}

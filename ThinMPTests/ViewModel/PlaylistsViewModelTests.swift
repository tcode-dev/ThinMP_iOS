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

    /// Service のモックと同じ 2 件を持つ Repository のモック。書き込みはこちらで観測する
    private func makeRepository() -> PlaylistRepositoryMock {
        return PlaylistRepositoryMock(playlists: [
            PlaylistEntity(playlistId: PlaylistId(id: "a"), name: "A", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistEntity(playlistId: PlaylistId(id: "b"), name: "B", songIds: [SongId(id: 3)]),
        ])
    }

    @Test
    func saveWritesEditedOrderToRepository() async {
        let repository = makeRepository()
        let vm = PlaylistsViewModel(playlistsService: makeService(), playlistRepository: repository)

        await vm.load().value
        vm.playlists.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(repository.findAll().map { $0.playlistId } == [PlaylistId(id: "b"), PlaylistId(id: "a")])
    }

    @Test
    func createAndAddWriteToRepository() {
        let repository = makeRepository()
        let vm = PlaylistsViewModel(playlistsService: makeService(), playlistRepository: repository)

        vm.create(songId: SongId(id: 5), name: "New")
        vm.add(playlistId: PlaylistId(id: "a"), songId: SongId(id: 6))

        #expect(repository.findAll().map { $0.name } == ["A", "B", "New"])
        #expect(repository.findAll()[2].songIds == [SongId(id: 5)])
        #expect(repository.findById(playlistId: PlaylistId(id: "a"))?.songIds == [SongId(id: 1), SongId(id: 2), SongId(id: 6)])
    }

    @Test
    func deleteRemovesFromRepositoryThenReloads() async {
        let service = makeService()
        let repository = makeRepository()
        let vm = PlaylistsViewModel(playlistsService: service, playlistRepository: repository)

        await vm.load().value
        vm.delete(playlistId: PlaylistId(id: "a"))
        await Task.yield()

        #expect(repository.findAll().map { $0.playlistId } == [PlaylistId(id: "b")])
        #expect(service.findAllCalls == 2)
    }
}

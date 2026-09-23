//
//  PlaylistRegisterViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct PlaylistRegisterViewModelTests {
    private func makeService() -> PlaylistsServiceMock {
        return PlaylistsServiceMock(playlists: [
            PlaylistModel(playlistId: PlaylistId(id: "a"), primaryText: "A", artwork: nil, songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistModel(playlistId: PlaylistId(id: "b"), primaryText: "B", artwork: nil, songIds: [SongId(id: 3)]),
        ])
    }

    private func makeRepository() -> PlaylistRepositoryMock {
        return PlaylistRepositoryMock(playlists: [
            PlaylistEntity(playlistId: PlaylistId(id: "a"), name: "A", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistEntity(playlistId: PlaylistId(id: "b"), name: "B", songIds: [SongId(id: 3)]),
        ])
    }

    @Test
    func loadMarksPlaylistsContainingTheSong() async {
        let service = makeService()
        let vm = PlaylistRegisterViewModel(playlistsService: service)

        await vm.load(songId: SongId(id: 2)).value

        #expect(vm.playlists?.map { $0.playlistId.id } == ["a", "b"])
        #expect(vm.registeredPlaylistIds == [PlaylistId(id: "a")])
        #expect(vm.isRegistered(playlistId: PlaylistId(id: "a")))
        #expect(!vm.isRegistered(playlistId: PlaylistId(id: "b")))
        #expect(service.findAllCalls == 1)
    }

    @Test
    func loadMarksNothingWhenTheSongIsInNoPlaylist() async {
        let vm = PlaylistRegisterViewModel(playlistsService: makeService())

        await vm.load(songId: SongId(id: 99)).value

        #expect(vm.registeredPlaylistIds.isEmpty)
    }

    /// 読み込み前の空と、プレイリストが 1 つも無い空を区別できる
    @Test
    func playlistsTellAnEmptyLibraryFromANotYetLoadedOne() async {
        let vm = PlaylistRegisterViewModel(playlistsService: PlaylistsServiceMock(playlists: []))

        #expect(vm.playlists == nil)

        await vm.load(songId: SongId(id: 1)).value

        #expect(vm.playlists?.isEmpty == true)
    }

    @Test
    func createAndAddWriteToRepository() {
        let repository = makeRepository()
        let vm = PlaylistRegisterViewModel(playlistsService: makeService(), playlistRepository: repository)

        vm.create(songId: SongId(id: 5), name: "New")
        vm.add(playlistId: PlaylistId(id: "a"), songId: SongId(id: 6))

        #expect(repository.findAll().map { $0.name } == ["A", "B", "New"])
        #expect(repository.findAll()[2].songIds == [SongId(id: 5)])
        #expect(repository.findById(playlistId: PlaylistId(id: "a"))?.songIds == [SongId(id: 1), SongId(id: 2), SongId(id: 6)])
    }

    /// 登録モーダルは読み込みを待たずに作成できる(一覧が空のうちに「プレイリストを作成」を押せる)
    @Test
    func createWorksBeforeTheLoadFinishes() {
        let repository = makeRepository()
        let vm = PlaylistRegisterViewModel(playlistsService: makeService(), playlistRepository: repository)

        #expect(vm.playlists == nil)
        vm.create(songId: SongId(id: 5), name: "New")

        #expect(repository.findAll().map { $0.name } == ["A", "B", "New"])
    }
}

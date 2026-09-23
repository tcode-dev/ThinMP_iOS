//
//  PlaylistDetailViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct PlaylistDetailViewModelTests {
    private let playlistId = PlaylistId(id: "p1")

    private func makeService() -> PlaylistDetailServiceMock {
        return PlaylistDetailServiceMock(playlists: [
            PlaylistDetailModel(playlistId: playlistId, primaryText: "P", artwork: nil, songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)]),
        ])
    }

    @Test
    func loadPublishesPlaylist() async {
        let vm = PlaylistDetailViewModel(playlistDetailService: makeService())

        await vm.load(playlistId: playlistId).value

        #expect(vm.playlist?.primaryText == "P")
        #expect(vm.playlist?.songs.map { $0.songId.id } == [1, 2, 3])
    }

    @Test
    func loadKeepsStateWhenPlaylistIsMissing() async {
        let vm = PlaylistDetailViewModel(playlistDetailService: makeService())

        await vm.load(playlistId: PlaylistId(id: "missing")).value

        #expect(vm.playlist == nil)
    }

    @Test
    func saveWritesEditedNameAndSongOrderToRepository() async {
        let repository = PlaylistRepositoryMock(playlists: [PlaylistEntity(playlistId: playlistId, name: "P", songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)])])
        let vm = PlaylistDetailViewModel(playlistDetailService: makeService(), playlistRepository: repository)

        await vm.load(playlistId: playlistId).value
        vm.playlist?.songs.move(fromOffsets: [2], toOffset: 0)
        vm.playlist?.songs.remove(atOffsets: [2])
        vm.save(playlistId: playlistId, name: "Renamed")

        #expect(repository.updateCalls.count == 1)
        #expect(repository.updateCalls[0].playlistId == playlistId)
        #expect(repository.updateCalls[0].name == "Renamed")
        #expect(repository.updateCalls[0].songIds.map { $0.id } == [3, 1])
    }

    /// 読み込みが終わる前に完了を押しても、空の songs でプレイリストの曲を消さない
    @Test
    func saveBeforeLoadDoesNotTouchRepository() {
        let repository = PlaylistRepositoryMock(playlists: [PlaylistEntity(playlistId: playlistId, name: "P", songIds: [SongId(id: 1), SongId(id: 2)])])
        let vm = PlaylistDetailViewModel(playlistDetailService: makeService(), playlistRepository: repository)

        #expect(!vm.isLoaded)
        vm.save(playlistId: playlistId, name: "Renamed")

        #expect(repository.updateCalls.isEmpty)
        #expect(repository.findById(playlistId: playlistId)?.songIds == [SongId(id: 1), SongId(id: 2)])
    }
}

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
            PlaylistDetailModel(playlistId: playlistId, primaryText: "P", songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)]),
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
    func saveWritesEditedNameAndSongOrder() async {
        let service = makeService()
        let vm = PlaylistDetailViewModel(playlistDetailService: service)

        await vm.load(playlistId: playlistId).value
        vm.playlist?.songs.move(fromOffsets: [2], toOffset: 0)
        vm.playlist?.songs.remove(atOffsets: [2])
        vm.save(playlistId: playlistId, name: "Renamed")

        #expect(service.updateCalls.count == 1)
        #expect(service.updateCalls[0].playlistId == playlistId)
        #expect(service.updateCalls[0].name == "Renamed")
        #expect(service.updateCalls[0].songIds.map { $0.id } == [3, 1])
    }
}

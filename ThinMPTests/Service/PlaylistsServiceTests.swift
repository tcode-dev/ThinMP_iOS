//
//  PlaylistsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

struct PlaylistsServiceTests {
    private func makeService() -> PlaylistsService {
        let playlists = [
            PlaylistEntity(playlistId: PlaylistId(id: "p1"), name: "A", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p2"), name: "B", songIds: [SongId(id: 3)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p3"), name: "C", songIds: [SongId(id: 2)]),
        ]
        let details = playlists.map { PlaylistDetailModel(playlistId: $0.playlistId, primaryText: $0.name, songs: []) }

        return PlaylistsService(
            playlistRepository: PlaylistRepositoryMock(playlists: playlists),
            playlistDetailService: PlaylistDetailServiceMock(playlists: details)
        )
    }

    @Test
    func findRegisteredIdsReturnsPlaylistsContainingSong() {
        let service = makeService()

        #expect(service.findRegisteredIds(songId: SongId(id: 2)).map { $0.id } == ["p1", "p3"])
    }

    @Test
    func findRegisteredIdsReturnsEmptyWhenSongIsNotInAnyPlaylist() {
        let service = makeService()

        #expect(service.findRegisteredIds(songId: SongId(id: 99)).isEmpty)
    }
}

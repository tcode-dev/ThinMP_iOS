//
//  PlaylistsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct PlaylistsServiceTests {
    private func makeService() -> PlaylistsService {
        let playlists = [
            PlaylistEntity(playlistId: PlaylistId(id: "p1"), name: "A", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p2"), name: "B", songIds: [SongId(id: 3)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p3"), name: "C", songIds: [SongId(id: 2)]),
        ]
        let details = playlists.map { PlaylistDetailModel(playlistId: $0.playlistId, primaryText: $0.name, songs: $0.songIds.map { .fake(id: $0.id) }) }

        return PlaylistsService(
            playlistRepository: PlaylistRepositoryMock(playlists: playlists),
            playlistDetailService: PlaylistDetailServiceMock(playlists: details)
        )
    }

    @Test
    func findAllCarriesSongIdsInPlaylistOrder() async {
        let playlists = await makeService().findAll()

        #expect(playlists.map { $0.id } == ["p1", "p2", "p3"])
        #expect(playlists.map { $0.primaryText } == ["A", "B", "C"])
        #expect(playlists.map { $0.songIds.map { $0.id } } == [[1, 2], [3], [2]])
    }

    @Test
    func containsSongIdTellsWhichPlaylistsAlreadyHaveTheSong() async {
        let playlists = await makeService().findAll()

        #expect(playlists.filter { $0.contains(songId: SongId(id: 2)) }.map { $0.id } == ["p1", "p3"])
        #expect(playlists.filter { $0.contains(songId: SongId(id: 99)) }.isEmpty)
    }
}

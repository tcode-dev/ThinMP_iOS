//
//  PlaylistDetailServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

@MainActor
struct PlaylistDetailServiceTests {
    private let playlistId = PlaylistId(id: "p1")

    private func makeService(playlistSongIds: [UInt64], librarySongIds: [UInt64]) -> (PlaylistDetailService, PlaylistRepositoryMock) {
        let playlistRepository = PlaylistRepositoryMock(playlists: [
            PlaylistEntity(playlistId: playlistId, name: "My Playlist", songIds: playlistSongIds.map { SongId(id: $0) }),
        ])
        let songRepository = SongRepositoryMock(songs: librarySongIds.map { .fake(id: $0, title: "Song \($0)") })
        let service = PlaylistDetailService(
            playlistRepository: playlistRepository,
            songRepository: songRepository,
            playlistRegister: PlaylistRegister(repository: playlistRepository)
        )

        return (service, playlistRepository)
    }

    @Test
    func findByIdReturnsSongsInPlaylistOrder() async throws {
        let (service, playlistRepository) = makeService(playlistSongIds: [3, 1, 2], librarySongIds: [1, 2, 3])

        let model = try #require(await service.findById(playlistId: playlistId))

        #expect(model.playlistId.id == "p1")
        #expect(model.primaryText == "My Playlist")
        #expect(model.songs.map { $0.songId.id } == [3, 1, 2])
        #expect(playlistRepository.updateCalls.isEmpty)
    }

    @Test
    func findByIdRemovesSongsMissingFromLibrary() async throws {
        let (service, playlistRepository) = makeService(playlistSongIds: [1, 2, 3], librarySongIds: [1, 3])

        let model = try #require(await service.findById(playlistId: playlistId))

        #expect(model.songs.map { $0.songId.id } == [1, 3])
        #expect(playlistRepository.updateCalls.count == 1)
        #expect(playlistRepository.updateCalls[0].playlistId.id == "p1")
        #expect(playlistRepository.updateCalls[0].name == "My Playlist")
        #expect(playlistRepository.updateCalls[0].songIds.map { $0.id } == [1, 3])
        #expect(playlistRepository.findById(playlistId: playlistId)?.songIds.map { $0.id } == [1, 3])
    }

    @Test
    func findByIdWithAllSongsMissingReturnsEmpty() async throws {
        let (service, playlistRepository) = makeService(playlistSongIds: [1, 2], librarySongIds: [])

        let model = try #require(await service.findById(playlistId: playlistId))

        #expect(model.songs.isEmpty)
        #expect(playlistRepository.updateCalls.count == 1)
        #expect(playlistRepository.updateCalls[0].songIds.isEmpty)
    }

    @Test
    func findByIdsMapsEachPlaylist() async {
        let playlistRepository = PlaylistRepositoryMock(playlists: [
            PlaylistEntity(playlistId: PlaylistId(id: "p1"), name: "One", songIds: [SongId(id: 1)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p2"), name: "Two", songIds: [SongId(id: 2)]),
        ])
        let service = PlaylistDetailService(
            playlistRepository: playlistRepository,
            songRepository: SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 2)]),
            playlistRegister: PlaylistRegister(repository: playlistRepository)
        )

        let models = await service.findByIds(playlistIds: [PlaylistId(id: "p2"), PlaylistId(id: "p1")])

        #expect(models.map { $0.primaryText } == ["One", "Two"])
        #expect(models.map { $0.songs.count } == [1, 1])
    }

    /// SongRepository.findByIds はライブラリ全件を舐めるので、プレイリスト数に関係なく 1 回で済ませる
    @Test
    func findByIdsQueriesSongRepositoryOnceForAllPlaylists() async {
        let playlistRepository = PlaylistRepositoryMock(playlists: [
            PlaylistEntity(playlistId: PlaylistId(id: "p1"), name: "One", songIds: [SongId(id: 1), SongId(id: 2)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p2"), name: "Two", songIds: [SongId(id: 2), SongId(id: 3)]),
            PlaylistEntity(playlistId: PlaylistId(id: "p3"), name: "Three", songIds: [SongId(id: 9)]),
        ])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)])
        let service = PlaylistDetailService(
            playlistRepository: playlistRepository,
            songRepository: songRepository,
            playlistRegister: PlaylistRegister(repository: playlistRepository)
        )

        let models = await service.findByIds(playlistIds: [PlaylistId(id: "p1"), PlaylistId(id: "p2"), PlaylistId(id: "p3")])

        #expect(songRepository.findByIdsCalls.count == 1)
        #expect(songRepository.findByIdsCalls[0].map { $0.id } == [1, 2, 3, 9])
        #expect(models.map { $0.songs.map { $0.songId.id } } == [[1, 2], [2, 3], []])
        // 端末に無い曲 9 は p3 からだけ取り除かれる
        #expect(playlistRepository.updateCalls.map { $0.playlistId.id } == ["p3"])
        #expect(playlistRepository.updateCalls[0].songIds.isEmpty)
    }

    @Test
    func findByIdReturnsNilWhenPlaylistIsMissing() async {
        let (service, playlistRepository) = makeService(playlistSongIds: [1], librarySongIds: [1])

        let model = await service.findById(playlistId: PlaylistId(id: "missing"))

        #expect(model == nil)
        #expect(playlistRepository.updateCalls.isEmpty)
    }
}

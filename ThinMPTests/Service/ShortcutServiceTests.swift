//
//  ShortcutServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

@MainActor
struct ShortcutServiceTests {
    private let artistShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s1"), target: .artist(ArtistId(id: 10)))
    private let albumShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s2"), target: .album(AlbumId(id: 20)))
    private let playlistShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s3"), target: .playlist(PlaylistId(id: "p1")))

    private func makeService(
        shortcuts: [ShortcutEntity],
        artistIds: [UInt64] = [10],
        albumIds: [UInt64] = [20],
        playlistIds: [String] = ["p1"]
    ) -> (ShortcutService, ShortcutRepositoryMock) {
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: shortcuts)
        let service = ShortcutService(
            shortcutRepository: shortcutRepository,
            artistDetailService: ArtistDetailServiceMock(artists: artistIds.map {
                ArtistDetailModel(artistId: ArtistId(id: $0), primaryText: "Artist \($0)", artwork: nil, albums: [], songs: [])
            }),
            albumDetailService: AlbumDetailServiceMock(albums: albumIds.map {
                AlbumDetailModel(albumId: AlbumId(id: $0), primaryText: "Album \($0)", secondaryText: nil, artwork: nil, songs: [])
            }),
            playlistDetailService: PlaylistDetailServiceMock(playlists: playlistIds.map {
                PlaylistDetailModel(playlistId: PlaylistId(id: $0), primaryText: "Playlist \($0)", artwork: nil, songs: [])
            })
        )

        return (service, shortcutRepository)
    }

    @Test
    func resolvesEachTypeInRepositoryOrder() async {
        let (service, shortcutRepository) = makeService(shortcuts: [playlistShortcut, artistShortcut, albumShortcut])

        let models = await service.findAll()

        #expect(models.map { $0.shortcutId.id } == ["s3", "s1", "s2"])
        #expect(models.map { $0.target } == [.playlist(PlaylistId(id: "p1")), .artist(ArtistId(id: 10)), .album(AlbumId(id: 20))])
        #expect(models.map { $0.primaryText } == ["Playlist p1", "Artist 10", "Album 20"])
        #expect(shortcutRepository.updateCalls.isEmpty)
    }

    @Test
    func removesShortcutsWhoseItemNoLongerExists() async {
        let (service, shortcutRepository) = makeService(shortcuts: [artistShortcut, albumShortcut, playlistShortcut], albumIds: [])

        let models = await service.findAll()

        #expect(models.map { $0.shortcutId.id } == ["s1", "s3"])
        #expect(shortcutRepository.updateCalls.count == 1)
        #expect(shortcutRepository.updateCalls[0] == [ShortcutId(id: "s1"), ShortcutId(id: "s3")])
    }

    @Test
    func returnsEmptyWhenNoShortcuts() async {
        let (service, shortcutRepository) = makeService(shortcuts: [])

        #expect(await service.findAll().isEmpty)
        #expect(shortcutRepository.updateCalls.isEmpty)
    }
}

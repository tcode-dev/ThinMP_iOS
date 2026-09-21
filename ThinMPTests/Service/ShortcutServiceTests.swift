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
    private let artistShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s1"), itemId: ItemId(id: "10"), type: .ARTIST)
    private let albumShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s2"), itemId: ItemId(id: "20"), type: .ALBUM)
    private let playlistShortcut = ShortcutEntity(shortcutId: ShortcutId(id: "s3"), itemId: ItemId(id: "p1"), type: .PLAYLIST)

    private func makeService(
        shortcuts: [ShortcutEntity],
        artistIds: [UInt64] = [10],
        albumIds: [UInt64] = [20],
        playlistIds: [String] = ["p1"]
    ) -> (ShortcutService, ShortcutRepositoryMock) {
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: shortcuts)
        let service = ShortcutService(
            shortcutRepository: shortcutRepository,
            shortcutRegister: ShortcutRegister(repository: shortcutRepository),
            artistDetailService: ArtistDetailServiceMock(artists: artistIds.map {
                ArtistDetailModel(artistId: ArtistId(id: $0), primaryText: "Artist \($0)", secondaryText: nil, artwork: nil, albums: [], songs: [])
            }),
            albumDetailService: AlbumDetailServiceMock(albums: albumIds.map {
                AlbumDetailModel(albumId: AlbumId(id: $0), primaryText: "Album \($0)", secondaryText: nil, artwork: nil, songs: [])
            }),
            playlistDetailService: PlaylistDetailServiceMock(playlists: playlistIds.map {
                PlaylistDetailModel(playlistId: PlaylistId(id: $0), primaryText: "Playlist \($0)", secondaryText: nil, artwork: nil, songs: [])
            })
        )

        return (service, shortcutRepository)
    }

    @Test
    func resolvesEachTypeInRepositoryOrder() async {
        let (service, shortcutRepository) = makeService(shortcuts: [playlistShortcut, artistShortcut, albumShortcut])

        let models = await service.findAll()

        #expect(models.map { $0.shortcutId.id } == ["s3", "s1", "s2"])
        #expect(models.map { $0.type } == [ShortcutType.PLAYLIST.rawValue, ShortcutType.ARTIST.rawValue, ShortcutType.ALBUM.rawValue])
        #expect(models.map { $0.primaryText } == ["Playlist p1", "Artist 10", "Album 20"])
        #expect(models.map { $0.itemId.id } == ["p1", "10", "20"])
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

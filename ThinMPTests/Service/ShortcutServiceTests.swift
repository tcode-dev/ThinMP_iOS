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
            albumsService: AlbumsServiceMock(albums: albumIds.map {
                AlbumModel(albumId: AlbumId(id: $0), primaryText: "Album \($0)")
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
        #expect(shortcutRepository.deleteCalls.isEmpty)
    }

    @Test
    func removesShortcutsWhoseItemNoLongerExists() async {
        let (service, shortcutRepository) = makeService(shortcuts: [artistShortcut, albumShortcut, playlistShortcut], albumIds: [])

        let models = await service.findAll()

        #expect(models.map { $0.shortcutId.id } == ["s1", "s3"])
        #expect(shortcutRepository.deleteCalls == [.album(AlbumId(id: 20))])
        #expect(shortcutRepository.updateCalls.isEmpty)
        #expect(shortcutRepository.findAll().map { $0.shortcutId.id } == ["s1", "s3"])
    }

    /// 走査中に(別のページで)追加されたショートカットは、端末から消えたものを取り除いても残る
    @Test
    func keepsShortcutAddedDuringScan() async {
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: [artistShortcut, albumShortcut])
        let artistDetailService = ArtistDetailServiceMock(artists: [
            ArtistDetailModel(artistId: ArtistId(id: 10), primaryText: "Artist 10", artwork: nil, albums: [], songs: []),
        ])
        artistDetailService.onFindByIds = {
            runOnMainActor { shortcutRepository.add(target: .artist(ArtistId(id: 11))) }
        }
        let service = ShortcutService(
            shortcutRepository: shortcutRepository,
            artistDetailService: artistDetailService,
            albumsService: AlbumsServiceMock(albums: []),
            playlistDetailService: PlaylistDetailServiceMock(playlists: [])
        )

        _ = await service.findAll()

        #expect(shortcutRepository.findAll().map { $0.target } == [.artist(ArtistId(id: 11)), .artist(ArtistId(id: 10))])
    }

    @Test
    func returnsEmptyWhenNoShortcuts() async {
        let (service, shortcutRepository) = makeService(shortcuts: [])

        #expect(await service.findAll().isEmpty)
        #expect(shortcutRepository.deleteCalls.isEmpty)
    }
}

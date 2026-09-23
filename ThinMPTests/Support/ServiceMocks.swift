//
//  ServiceMocks.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import MediaPlayer
@testable import ThinMP

// Service / ViewModel のテストで他の Service を差し替えるためのモック
// 呼び出しを記録できるように class にしている

final class ArtistDetailServiceMock: ArtistDetailServiceProtocol {
    let artists: [ArtistDetailModel]

    init(artists: [ArtistDetailModel]) {
        self.artists = artists
    }

    func findById(artistId: ArtistId) -> ArtistDetailModel? {
        return artists.first { $0.artistId == artistId }
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistDetailModel] {
        return artistIds.compactMap { artistId in artists.first { $0.artistId == artistId } }
    }
}

final class AlbumDetailServiceMock: AlbumDetailServiceProtocol {
    let albums: [AlbumDetailModel]

    init(albums: [AlbumDetailModel]) {
        self.albums = albums
    }

    func findById(albumId: AlbumId) -> AlbumDetailModel? {
        return albums.first { $0.albumId == albumId }
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        return albumIds.compactMap { albumId in albums.first { $0.albumId == albumId } }
    }
}

final class PlaylistDetailServiceMock: PlaylistDetailServiceProtocol {
    let playlists: [PlaylistDetailModel]

    init(playlists: [PlaylistDetailModel]) {
        self.playlists = playlists
    }

    func findById(playlistId: PlaylistId) -> PlaylistDetailModel? {
        return playlists.first { $0.playlistId == playlistId }
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel] {
        return playlistIds.compactMap { playlistId in playlists.first { $0.playlistId == playlistId } }
    }

    func findAll() -> [PlaylistDetailModel] {
        return playlists
    }
}

final class ShortcutServiceMock: ShortcutServiceProtocol {
    let shortcuts: [ShortcutModel]
    private(set) var findAllCalls = 0

    init(shortcuts: [ShortcutModel] = []) {
        self.shortcuts = shortcuts
    }

    func findAll() -> [ShortcutModel] {
        findAllCalls += 1

        return shortcuts
    }
}

final class MainServiceMock: MainServiceProtocol {
    var settings: MainSettings
    let shortcuts: [ShortcutModel]
    let albums: [AlbumModel]
    private(set) var findShortcutsCalls = 0
    private(set) var findRecentlyAlbumsCalls = 0
    private(set) var savedSettings: [MainSettings] = []

    init(settings: MainSettings, shortcuts: [ShortcutModel] = [], albums: [AlbumModel] = []) {
        self.settings = settings
        self.shortcuts = shortcuts
        self.albums = albums
    }

    func findRecentlyAlbums() -> [AlbumModel] {
        findRecentlyAlbumsCalls += 1

        return albums
    }

    func findShortcuts() -> [ShortcutModel] {
        findShortcutsCalls += 1

        return shortcuts
    }

    func loadSettings() -> MainSettings {
        return settings
    }

    func save(settings: MainSettings) {
        savedSettings.append(settings)
        self.settings = settings
    }
}

final class FavoriteSongsServiceMock: FavoriteSongsServiceProtocol {
    let songs: [SongModel]

    init(songs: [SongModel]) {
        self.songs = songs
    }

    func findAll() -> [SongModel] {
        return songs
    }
}

final class FavoriteArtistsServiceMock: FavoriteArtistsServiceProtocol {
    let artists: [ArtistModel]

    init(artists: [ArtistModel]) {
        self.artists = artists
    }

    func findAll() -> [ArtistModel] {
        return artists
    }
}

final class AlbumsServiceMock: AlbumsServiceProtocol {
    let albums: [AlbumModel]
    private(set) var findAllCalls = 0

    init(albums: [AlbumModel]) {
        self.albums = albums
    }

    func findAll() -> [AlbumModel] {
        findAllCalls += 1

        return albums
    }
}

final class ArtistsServiceMock: ArtistsServiceProtocol {
    let artists: [ArtistModel]
    private(set) var findAllCalls = 0

    init(artists: [ArtistModel]) {
        self.artists = artists
    }

    func findAll() -> [ArtistModel] {
        findAllCalls += 1

        return artists
    }
}

final class SongsServiceMock: SongsServiceProtocol {
    let songs: [SongModel]
    private(set) var findAllCalls = 0

    init(songs: [SongModel]) {
        self.songs = songs
    }

    func findAll() -> [SongModel] {
        findAllCalls += 1

        return songs
    }
}

final class PlaylistsServiceMock: PlaylistsServiceProtocol {
    let playlists: [PlaylistModel]
    private(set) var findAllCalls = 0

    init(playlists: [PlaylistModel]) {
        self.playlists = playlists
    }

    func findAll() -> [PlaylistModel] {
        findAllCalls += 1

        return playlists
    }
}

/// findAll を呼び出し側が resume するまで待たせる FavoriteSongsService
/// 2 回目の load が 1 回目を打ち切ることを確認するのに使う
final class BlockingFavoriteSongsServiceMock: FavoriteSongsServiceProtocol {
    private var continuations: [CheckedContinuation<[SongModel], Never>] = []

    var pendingCount: Int { continuations.count }

    func findAll() async -> [SongModel] {
        return await withCheckedContinuation { continuations.append($0) }
    }

    /// 最も古い保留中の findAll を songs で完了させる
    func resume(with songs: [SongModel]) {
        continuations.removeFirst().resume(returning: songs)
    }
}

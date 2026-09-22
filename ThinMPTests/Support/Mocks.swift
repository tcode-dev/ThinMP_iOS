//
//  Mocks.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import MediaPlayer
@testable import ThinMP

// Service のテストで Repository / 他 Service を差し替えるためのモック
// 呼び出しを記録できるように class にしている

final class FavoriteSongRepositoryMock: FavoriteSongRepositoryProtocol {
    var songIds: [SongId]
    private(set) var updateCalls: [[SongId]] = []

    init(songIds: [SongId] = []) {
        self.songIds = songIds
    }

    func add(songId: SongId) {
        songIds.append(songId)
    }

    func findAll() -> [SongId] {
        return songIds
    }

    func exists(songId: SongId) -> Bool {
        return songIds.contains(songId)
    }

    func update(songIds: [SongId]) {
        updateCalls.append(songIds)
        self.songIds = songIds
    }

    func delete(songId: SongId) {
        songIds.removeAll { $0 == songId }
    }
}

final class FavoriteArtistRepositoryMock: FavoriteArtistRepositoryProtocol {
    var artistIds: [ArtistId]
    private(set) var updateCalls: [[ArtistId]] = []

    init(artistIds: [ArtistId] = []) {
        self.artistIds = artistIds
    }

    func findAll() -> [ArtistId] {
        return artistIds
    }

    func exists(artistId: ArtistId) -> Bool {
        return artistIds.contains(artistId)
    }

    func add(artistId: ArtistId) {
        artistIds.append(artistId)
    }

    func update(artistIds: [ArtistId]) {
        updateCalls.append(artistIds)
        self.artistIds = artistIds
    }

    func delete(artistId: ArtistId) {
        artistIds.removeAll { $0 == artistId }
    }
}

final class PlaylistRepositoryMock: PlaylistRepositoryProtocol {
    struct UpdateCall {
        let playlistId: PlaylistId
        let name: String
        let songIds: [SongId]
    }

    var playlists: [PlaylistEntity]
    private(set) var updateCalls: [UpdateCall] = []

    init(playlists: [PlaylistEntity] = []) {
        self.playlists = playlists
    }

    func create(songId: SongId, name: String) {
        playlists.append(PlaylistEntity(playlistId: PlaylistId(id: UUID().uuidString), name: name, songIds: [songId]))
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        guard let index = playlists.firstIndex(where: { $0.playlistId == playlistId }) else { return }

        playlists[index].songIds.append(songId)
    }

    func findAll() -> [PlaylistEntity] {
        return playlists
    }

    func findById(playlistId: PlaylistId) -> PlaylistEntity? {
        return playlists.first { $0.playlistId == playlistId }
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistEntity] {
        let ids = Set(playlistIds)

        return playlists.filter { ids.contains($0.playlistId) }
    }

    func update(playlistIds: [PlaylistId]) {
        playlists = playlistIds.compactMap { playlistId in playlists.first { $0.playlistId == playlistId } }
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        updateCalls.append(UpdateCall(playlistId: playlistId, name: name, songIds: songIds))

        guard let index = playlists.firstIndex(where: { $0.playlistId == playlistId }) else { return }

        playlists[index].name = name
        playlists[index].songIds = songIds
    }

    func delete(playlistId: PlaylistId) {
        playlists.removeAll { $0.playlistId == playlistId }
    }
}

final class ShortcutRepositoryMock: ShortcutRepositoryProtocol {
    var shortcuts: [ShortcutEntity]
    private(set) var updateCalls: [[ShortcutId]] = []

    init(shortcuts: [ShortcutEntity] = []) {
        self.shortcuts = shortcuts
    }

    func add(itemId: ItemId, type: ShortcutType) {}

    func findAll() -> [ShortcutEntity] {
        return shortcuts
    }

    func exists(itemId: ItemId, type: ShortcutType) -> Bool {
        return false
    }

    func update(shortcutIds: [ShortcutId]) {
        updateCalls.append(shortcutIds)
        shortcuts = shortcutIds.compactMap { shortcutId in shortcuts.first { $0.shortcutId == shortcutId } }
    }

    func delete(itemId: ItemId, type: ShortcutType) {}
}

/// 端末のライブラリの代わり。findByIds は実装と同じく songIds の順序で返す
final class SongRepositoryMock: SongRepositoryProtocol {
    let songs: [SongModel]
    /// findByIds に渡された songIds の履歴。ライブラリ全件取得の回数を数えるのに使う
    private(set) var findByIdsCalls: [[SongId]] = []

    init(songs: [SongModel]) {
        self.songs = songs
    }

    func findAll() -> [SongModel] {
        return songs
    }

    func findByIds(songIds: [SongId]) -> [SongModel] {
        findByIdsCalls.append(songIds)

        return songIds.compactMap { songId in songs.first { $0.songId == songId } }
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        return []
    }

    func findByAlbumIds(albumIds: [AlbumId]) -> [SongModel] {
        return []
    }
}

final class ArtistRepositoryMock: ArtistRepositoryProtocol {
    let artists: [ArtistModel]

    init(artists: [ArtistModel]) {
        self.artists = artists
    }

    func findAll() -> [ArtistModel] {
        return artists
    }

    func findById(artistId: ArtistId) -> ArtistModel? {
        return artists.first { $0.artistId == artistId }
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        return artistIds.compactMap { artistId in artists.first { $0.artistId == artistId } }
    }
}

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
    struct UpdateCall {
        let playlistId: PlaylistId
        let name: String
        let songIds: [SongId]
    }

    let playlists: [PlaylistDetailModel]
    private(set) var updateCalls: [UpdateCall] = []

    init(playlists: [PlaylistDetailModel]) {
        self.playlists = playlists
    }

    func findById(playlistId: PlaylistId) -> PlaylistDetailModel? {
        return playlists.first { $0.playlistId == playlistId }
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel] {
        return playlistIds.compactMap { playlistId in playlists.first { $0.playlistId == playlistId } }
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        updateCalls.append(UpdateCall(playlistId: playlistId, name: name, songIds: songIds))
    }
}

// ViewModel のテストで Service を差し替えるためのモック

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
    private(set) var updateCalls: [[PlaylistId]] = []
    private(set) var createCalls: [(songId: SongId, name: String)] = []
    private(set) var addCalls: [(playlistId: PlaylistId, songId: SongId)] = []
    private(set) var deleteCalls: [PlaylistId] = []

    init(playlists: [PlaylistModel]) {
        self.playlists = playlists
    }

    func findAll() -> [PlaylistModel] {
        findAllCalls += 1

        return playlists
    }

    func create(songId: SongId, name: String) {
        createCalls.append((songId, name))
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        addCalls.append((playlistId, songId))
    }

    func update(playlistIds: [PlaylistId]) {
        updateCalls.append(playlistIds)
    }

    func delete(playlistId: PlaylistId) {
        deleteCalls.append(playlistId)
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

    func update(songIds: [SongId]) {}
}

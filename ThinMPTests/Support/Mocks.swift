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
        return songIds.contains { $0.equals(songId) }
    }

    func update(songIds: [SongId]) {
        updateCalls.append(songIds)
        self.songIds = songIds
    }

    func delete(songId: SongId) {
        songIds.removeAll { $0.equals(songId) }
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
        return artistIds.contains { $0.id == artistId.id }
    }

    func add(artistId: ArtistId) {
        artistIds.append(artistId)
    }

    func update(artistIds: [ArtistId]) {
        updateCalls.append(artistIds)
        self.artistIds = artistIds
    }

    func delete(artistId: ArtistId) {
        artistIds.removeAll { $0.id == artistId.id }
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
        guard let index = playlists.firstIndex(where: { $0.playlistId.id == playlistId.id }) else { return }

        playlists[index].songIds.append(songId)
    }

    func findAll() -> [PlaylistEntity] {
        return playlists
    }

    func findById(playlistId: PlaylistId) -> PlaylistEntity {
        return playlists.first { $0.playlistId.id == playlistId.id }!
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistEntity] {
        let ids = playlistIds.map { $0.id }

        return playlists.filter { ids.contains($0.playlistId.id) }
    }

    func update(playlistIds: [PlaylistId]) {
        playlists = playlistIds.compactMap { playlistId in playlists.first { $0.playlistId.id == playlistId.id } }
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        updateCalls.append(UpdateCall(playlistId: playlistId, name: name, songIds: songIds))

        guard let index = playlists.firstIndex(where: { $0.playlistId.id == playlistId.id }) else { return }

        playlists[index].name = name
        playlists[index].songIds = songIds
    }

    func delete(playlistId: PlaylistId) {
        playlists.removeAll { $0.playlistId.id == playlistId.id }
    }
}

final class ShortcutRepositoryMock: ShortcutRepositoryProtocol {
    var shortcuts: [ShortcutEntity]
    private(set) var updateCalls: [[ShortcutId]] = []

    init(shortcuts: [ShortcutEntity] = []) {
        self.shortcuts = shortcuts
    }

    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType) {}

    func findAll() -> [ShortcutEntity] {
        return shortcuts
    }

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool {
        return false
    }

    func update(shortcutIds: [ShortcutId]) {
        updateCalls.append(shortcutIds)
        shortcuts = shortcutIds.compactMap { shortcutId in shortcuts.first { $0.shortcutId == shortcutId } }
    }

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType) {}
}

/// 端末のライブラリの代わり。findByIds は実装と同じく songIds の順序で返す
final class SongRepositoryMock: SongRepositoryProtocol {
    let songs: [SongModel]

    init(songs: [SongModel]) {
        self.songs = songs
    }

    func findAll() -> [SongModel] {
        return songs
    }

    func findByIds(songIds: [SongId]) -> [SongModel] {
        return songIds.compactMap { songId in songs.first { $0.songId.equals(songId) } }
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
        return artists.first { $0.artistId.id == artistId.id }
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        return artistIds.compactMap { artistId in artists.first { $0.artistId.id == artistId.id } }
    }
}

final class ArtistDetailServiceMock: ArtistDetailServiceProtocol {
    let artists: [ArtistDetailModel]

    init(artists: [ArtistDetailModel]) {
        self.artists = artists
    }

    func findById(artistId: ArtistId) -> ArtistDetailModel? {
        return artists.first { $0.artistId.id == artistId.id }
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistDetailModel] {
        return artistIds.compactMap { artistId in artists.first { $0.artistId.id == artistId.id } }
    }
}

final class AlbumDetailServiceMock: AlbumDetailServiceProtocol {
    let albums: [AlbumDetailModel]

    init(albums: [AlbumDetailModel]) {
        self.albums = albums
    }

    func findById(albumId: AlbumId) -> AlbumDetailModel? {
        return albums.first { $0.albumId.id == albumId.id }
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        return albumIds.compactMap { albumId in albums.first { $0.albumId.id == albumId.id } }
    }
}

final class PlaylistDetailServiceMock: PlaylistDetailServiceProtocol {
    let playlists: [PlaylistDetailModel]

    init(playlists: [PlaylistDetailModel]) {
        self.playlists = playlists
    }

    func findById(playlistId: PlaylistId) -> PlaylistDetailModel {
        return playlists.first { $0.playlistId.id == playlistId.id }!
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel] {
        return playlistIds.compactMap { playlistId in playlists.first { $0.playlistId.id == playlistId.id } }
    }
}

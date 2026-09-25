//
//  RepositoryMocks.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Foundation
import MediaPlayer
@testable import ThinMP

/// 走査中(onFindByIds の中)にメインアクターで書き込むのに使う
/// 走査はバックグラウンドで呼ばれることも、同期のモックならメインスレッドのまま呼ばれることもあるので、
/// メインスレッドなら直接実行し、そうでなければメインキューで同期実行する(メインから main.sync するとクラッシュする)
func runOnMainActor(_ body: @MainActor () -> Void) {
    if Thread.isMainThread {
        MainActor.assumeIsolated(body)
    } else {
        DispatchQueue.main.sync {
            MainActor.assumeIsolated(body)
        }
    }
}

// Service / ViewModel のテストで Repository を差し替えるためのモック
// 呼び出しを記録できるように class にしている

final class FavoriteSongRepositoryMock: FavoriteSongRepositoryProtocol {
    var songIds: [SongId]
    private(set) var updateCalls: [[SongId]] = []
    private(set) var deleteCalls: [SongId] = []

    init(songIds: [SongId] = []) {
        self.songIds = songIds
    }

    func add(songId: SongId) {
        // 実装と同じく、登録済みなら何もしない
        if exists(songId: songId) {
            return
        }

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
        deleteCalls.append(songId)
        songIds.removeAll { $0 == songId }
    }
}

final class FavoriteArtistRepositoryMock: FavoriteArtistRepositoryProtocol {
    var artistIds: [ArtistId]
    private(set) var updateCalls: [[ArtistId]] = []
    private(set) var deleteCalls: [ArtistId] = []

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
        // 実装と同じく、登録済みなら何もしない
        if exists(artistId: artistId) {
            return
        }

        artistIds.append(artistId)
    }

    func update(artistIds: [ArtistId]) {
        updateCalls.append(artistIds)
        self.artistIds = artistIds
    }

    func delete(artistId: ArtistId) {
        deleteCalls.append(artistId)
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

        let playlist = playlists[index]

        // 実装と同じく、同じ曲は 1 つのプレイリストに 1 回しか登録しない
        if playlist.songIds.contains(songId) {
            return
        }

        playlists[index] = PlaylistEntity(playlistId: playlistId, name: playlist.name, songIds: playlist.songIds + [songId])
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

        playlists[index] = PlaylistEntity(playlistId: playlistId, name: name, songIds: songIds)
    }

    func delete(playlistId: PlaylistId) {
        playlists.removeAll { $0.playlistId == playlistId }
    }
}

final class ShortcutRepositoryMock: ShortcutRepositoryProtocol {
    var shortcuts: [ShortcutEntity]
    private(set) var updateCalls: [[ShortcutId]] = []
    private(set) var deleteCalls: [ShortcutTarget] = []

    init(shortcuts: [ShortcutEntity] = []) {
        self.shortcuts = shortcuts
    }

    func add(target: ShortcutTarget) {
        if exists(target: target) {
            return
        }

        // 実装と同じく新しいものが先頭
        shortcuts.insert(ShortcutEntity(shortcutId: ShortcutId(id: UUID().uuidString), target: target), at: 0)
    }

    func findAll() -> [ShortcutEntity] {
        return shortcuts
    }

    func exists(target: ShortcutTarget) -> Bool {
        return shortcuts.contains { $0.target == target }
    }

    func update(shortcutIds: [ShortcutId]) {
        updateCalls.append(shortcutIds)
        shortcuts = shortcutIds.compactMap { shortcutId in shortcuts.first { $0.shortcutId == shortcutId } }
    }

    func delete(target: ShortcutTarget) {
        deleteCalls.append(target)
        shortcuts.removeAll { $0.target == target }
    }
}

/// 端末のライブラリの代わり。findByIds は実装と同じく songIds の順序で返し、findByArtistId は songs を artistId で絞る
/// 走査はバックグラウンドから呼ばれるが、テストは呼ぶ前に設定して await の後に読むだけで同時には触らないので、@unchecked Sendable にしている
final class SongRepositoryMock: SongRepositoryProtocol, @unchecked Sendable {
    let songs: [SongModel]
    /// findByAlbumId が返す曲
    let albumSongs: [AlbumId: [SongModel]]
    /// クラウドにしか無い曲。findByIds には出ないが、findDeletedIds では削除されたことにならない
    let cloudSongIds: Set<SongId>
    /// findDeletedIds に渡された songIds の履歴。クラウドも含めた全件走査の回数を数えるのに使う
    private(set) var findDeletedIdsCalls: [[SongId]] = []
    /// findByIds に渡された songIds の履歴。ライブラリ全件取得の回数を数えるのに使う
    private(set) var findByIdsCalls: [[SongId]] = []
    /// findByIds の中(走査中)に呼ばれる。走査中に別の書き込みが入った状況を作るのに使う
    var onFindByIds: @Sendable () -> Void = {}

    init(songs: [SongModel], albumSongs: [AlbumId: [SongModel]] = [:], cloudSongIds: Set<SongId> = []) {
        self.songs = songs
        self.albumSongs = albumSongs
        self.cloudSongIds = cloudSongIds
    }

    func findAll() -> [SongModel] {
        return songs
    }

    func findByIds(songIds: [SongId]) -> [SongModel] {
        findByIdsCalls.append(songIds)
        onFindByIds()

        return songIds.compactMap { songId in songs.first { $0.songId == songId } }
    }

    func findDeletedIds(songIds: [SongId]) -> Set<SongId> {
        findDeletedIdsCalls.append(songIds)

        return Set(songIds).subtracting(songs.map { $0.songId }).subtracting(cloudSongIds)
    }

    func findByAlbumId(albumId: AlbumId) -> [SongModel] {
        return albumSongs[albumId] ?? []
    }

    func findByArtistId(artistId: ArtistId) -> [SongModel] {
        return songs.filter { $0.artistId == artistId }
    }
}

/// 走査はバックグラウンドから呼ばれるが、テストは呼ぶ前に設定して await の後に読むだけで同時には触らないので、@unchecked Sendable にしている
final class AlbumRepositoryMock: AlbumRepositoryProtocol, @unchecked Sendable {
    let albums: [AlbumModel]
    /// findByArtistId が返すアルバム
    let artistAlbums: [ArtistId: [AlbumModel]]
    /// findRecently が返すアルバム(count で先頭から切る)
    let recently: [AlbumModel]
    /// クラウドにしか無いアルバム。findByIds には出ないが、findDeletedIds では削除されたことにならない
    let cloudAlbumIds: Set<AlbumId>
    private(set) var findRecentlyCalls: [Int] = []

    init(albums: [AlbumModel] = [], artistAlbums: [ArtistId: [AlbumModel]] = [:], recently: [AlbumModel] = [], cloudAlbumIds: Set<AlbumId> = []) {
        self.albums = albums
        self.artistAlbums = artistAlbums
        self.recently = recently
        self.cloudAlbumIds = cloudAlbumIds
    }

    func findAll() -> [AlbumModel] {
        return albums
    }

    func findById(albumId: AlbumId) -> AlbumModel? {
        return albums.first { $0.albumId == albumId }
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumModel] {
        return albumIds.compactMap { albumId in albums.first { $0.albumId == albumId } }
    }

    func findDeletedIds(albumIds: [AlbumId]) -> Set<AlbumId> {
        return Set(albumIds).subtracting(albums.map { $0.albumId }).subtracting(cloudAlbumIds)
    }

    func findByArtistId(artistId: ArtistId) -> [AlbumModel] {
        return artistAlbums[artistId] ?? []
    }

    func findRecently(count: Int) -> [AlbumModel] {
        findRecentlyCalls.append(count)

        return Array(recently.prefix(count))
    }
}

/// 走査はバックグラウンドから呼ばれるが、テストは呼ぶ前に設定して await の後に読むだけで同時には触らないので、@unchecked Sendable にしている
final class ArtistRepositoryMock: ArtistRepositoryProtocol, @unchecked Sendable {
    let artists: [ArtistModel]
    /// クラウドにしか無いアーティスト。findByIds には出ないが、findDeletedIds では削除されたことにならない
    let cloudArtistIds: Set<ArtistId>
    /// findByIds の中(走査中)に呼ばれる。走査中に別の書き込みが入った状況を作るのに使う
    var onFindByIds: @Sendable () -> Void = {}

    init(artists: [ArtistModel], cloudArtistIds: Set<ArtistId> = []) {
        self.artists = artists
        self.cloudArtistIds = cloudArtistIds
    }

    func findAll() -> [ArtistModel] {
        return artists
    }

    func findById(artistId: ArtistId) -> ArtistModel? {
        return artists.first { $0.artistId == artistId }
    }

    func findByIds(artistIds: [ArtistId]) -> [ArtistModel] {
        onFindByIds()

        return artistIds.compactMap { artistId in artists.first { $0.artistId == artistId } }
    }

    func findDeletedIds(artistIds: [ArtistId]) -> Set<ArtistId> {
        return Set(artistIds).subtracting(artists.map { $0.artistId }).subtracting(cloudArtistIds)
    }
}

//
//  LegacyRealmFixture.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Foundation
import Testing
@testable import ThinMP

/// 移行テストに使う Realm データの仕様
/// Fixtures/legacy.realm はこの populate で作られている(generateLegacyRealmFixture を参照)
enum LegacyRealmFixture {
    static let fileName = "legacy.realm"

    static let favoriteSongIds: [UInt64] = [103, 101, 102]
    static let favoriteArtistIds: [UInt64] = [201, 202]
    /// 並び順どおり。"Empty" は曲が 0 件のプレイリスト
    static let playlists: [(name: String, songIds: [UInt64])] = [("Night", [103]), ("Morning", [101, 102]), ("Empty", [])]
    static let shortcutArtistId: UInt64 = 201
    static let shortcutAlbumId: UInt64 = 301
    static let shortcutPlaylistName = "Morning"

    @MainActor
    static func populate(_ repositories: TestRepositories) {
        // お気に入り曲: 追加してから並び替え
        repositories.favoriteSong.add(songId: SongId(id: 101))
        repositories.favoriteSong.add(songId: SongId(id: 102))
        repositories.favoriteSong.add(songId: SongId(id: 103))
        repositories.favoriteSong.update(songIds: favoriteSongIds.map { SongId(id: $0) })

        repositories.favoriteArtist.add(artistId: ArtistId(id: 201))
        repositories.favoriteArtist.add(artistId: ArtistId(id: 202))

        // プレイリスト: 作成順は Morning, Night, Empty。その後 Night, Morning, Empty に並び替え
        repositories.playlist.create(songId: SongId(id: 101), name: "Morning")
        repositories.playlist.create(songId: SongId(id: 103), name: "Night")
        repositories.playlist.create(songId: SongId(id: 101), name: "Empty")

        let created = repositories.playlist.findAll()
        let morning = created[0].playlistId
        let night = created[1].playlistId
        let empty = created[2].playlistId

        repositories.playlist.add(playlistId: morning, songId: SongId(id: 102))
        repositories.playlist.update(playlistId: empty, name: "Empty", songIds: [])
        repositories.playlist.update(playlistIds: [night, morning, empty])

        // ショートカット: 追加順は artist, album, playlist。findAll は新しい順
        repositories.shortcut.add(itemId: ItemId(id: String(shortcutArtistId)), type: .artist)
        repositories.shortcut.add(itemId: ItemId(id: String(shortcutAlbumId)), type: .album)
        repositories.shortcut.add(itemId: ItemId(id: morning.id), type: .playlist)
    }

    @MainActor
    static func verify(_ repositories: TestRepositories) {
        #expect(repositories.favoriteSong.findAll().map { $0.id } == favoriteSongIds)
        #expect(repositories.favoriteArtist.findAll().map { $0.id } == favoriteArtistIds)

        let playlists = repositories.playlist.findAll()

        #expect(playlists.map { $0.name } == self.playlists.map { $0.name })
        #expect(playlists.map { $0.songIds.map { $0.id } } == self.playlists.map { $0.songIds })

        let shortcuts = repositories.shortcut.findAll()
        let morningId = playlists.first { $0.name == shortcutPlaylistName }?.playlistId.id

        #expect(shortcuts.map { $0.type } == [.playlist, .album, .artist])
        #expect(shortcuts.map { $0.itemId.id } == [morningId, String(shortcutAlbumId), String(shortcutArtistId)])
    }
}

//
//  ShortcutTargetTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

/// ストアの行から ShortcutTarget を作る変換
/// Repository 越しには ShortcutRepositoryTests が間接的に見ているが、
/// 種別ごとの読み分けと、落とす行の条件はここで固定する
struct ShortcutTargetTests {
    @Test
    func readsEachType() {
        #expect(ShortcutTarget(itemId: "1", type: ShortcutType.artist.rawValue) == .artist(ArtistId(id: 1)))
        #expect(ShortcutTarget(itemId: "2", type: ShortcutType.album.rawValue) == .album(AlbumId(id: 2)))
        #expect(ShortcutTarget(itemId: "p1", type: ShortcutType.playlist.rawValue) == .playlist(PlaylistId(id: "p1")))
    }

    /// プレイリストの id は UUID の文字列なので、数値でなくても読める
    @Test
    func readsAPlaylistIdThatIsNotANumber() {
        #expect(ShortcutTarget(itemId: "not-a-number", type: ShortcutType.playlist.rawValue) == .playlist(PlaylistId(id: "not-a-number")))
    }

    /// アーティストとアルバムの itemId は persistentID なので、数値として読めない行は落とす
    @Test
    func dropsAnArtistOrAlbumIdThatIsNotAPersistentId() {
        #expect(ShortcutTarget(itemId: "not-a-number", type: ShortcutType.artist.rawValue) == nil)
        #expect(ShortcutTarget(itemId: "not-a-number", type: ShortcutType.album.rawValue) == nil)
    }

    @Test
    func dropsAnUnknownType() {
        #expect(ShortcutTarget(itemId: "1", type: 0) == nil)
        #expect(ShortcutTarget(itemId: "1", type: 99) == nil)
    }

    /// ストアに書き戻す type と itemId は、読んだときと同じものに戻る
    @Test
    func roundTripsThroughTheStoredColumns() {
        for target in [ShortcutTarget.artist(ArtistId(id: 1)), .album(AlbumId(id: 2)), .playlist(PlaylistId(id: "p1"))] {
            #expect(ShortcutTarget(itemId: target.itemId, type: target.type.rawValue) == target)
        }
    }
}

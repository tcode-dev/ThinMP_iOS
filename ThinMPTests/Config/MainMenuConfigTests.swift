//
//  MainMenuConfigTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Foundation
import Testing
@testable import ThinMP

/// MainMenuConfig / MainSectionConfig と UserDefaults の往復
/// 保存形式(並び順は rawValue の配列、表示 / 非表示は rawValue をキーにした Bool)は
/// リリース済みのアプリが書いたものと互換なので、ここで固定する
struct MainMenuConfigTests {
    /// テストごとに空の UserDefaults
    private func makeUserDefaults() -> UserDefaults {
        let name = "MainMenuConfigTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: name)!

        userDefaults.removePersistentDomain(forName: name)

        return userDefaults
    }

    @Test
    func defaultsToAllMenusVisibleInDeclarationOrder() {
        let config = MainMenuConfig(userDefaults: makeUserDefaults())

        #expect(config.load() == MainMenu.allCases.map { MainMenuSetting(menu: $0, visibility: true) })
    }

    @Test
    func saveRoundTripsOrderAndVisibility() {
        let userDefaults = makeUserDefaults()
        let config = MainMenuConfig(userDefaults: userDefaults)
        let menus = [
            MainMenuSetting(menu: .playlists, visibility: true),
            MainMenuSetting(menu: .songs, visibility: false),
            MainMenuSetting(menu: .artists, visibility: true),
            MainMenuSetting(menu: .albums, visibility: false),
            MainMenuSetting(menu: .favoriteSongs, visibility: true),
            MainMenuSetting(menu: .favoriteArtists, visibility: true),
        ]

        config.save(menus)

        #expect(config.load() == menus)
        // 別のインスタンスからも同じものが読める
        #expect(MainMenuConfig(userDefaults: userDefaults).load() == menus)
    }

    /// リリース済みのアプリが書いた形式: "sort" にラベル文字列の配列、ラベル文字列をキーに Bool
    @Test
    func readsLegacyStoredFormat() {
        let userDefaults = makeUserDefaults()

        userDefaults.set(["Songs", "Albums", "Artists", "Playlists", "FavoriteSongs", "FavoriteArtists"], forKey: "sort")
        userDefaults.set(false, forKey: "Albums")

        let menus = MainMenuConfig(userDefaults: userDefaults).load()

        #expect(menus.map { $0.menu } == [.songs, .albums, .artists, .playlists, .favoriteSongs, .favoriteArtists])
        #expect(menus.map { $0.visibility } == [true, false, true, true, true, true])
    }

    /// 保存した並び順に無いメニューは末尾に足し、知らない値は捨てる
    @Test
    func appendsMissingMenusAndDropsUnknownValues() {
        let userDefaults = makeUserDefaults()

        userDefaults.set(["Songs", "Unknown", "Artists"], forKey: "sort")

        let menus = MainMenuConfig(userDefaults: userDefaults).load().map { $0.menu }

        #expect(menus == [.songs, .artists, .albums, .favoriteArtists, .favoriteSongs, .playlists])
    }

    @Test
    func sectionVisibilityDefaultsToTrueAndRoundTrips() {
        let userDefaults = makeUserDefaults()
        let config = MainSectionConfig(userDefaults: userDefaults)

        #expect(config.isShortcutVisible)
        #expect(config.isRecentlyVisible)

        config.isShortcutVisible = false

        #expect(!config.isShortcutVisible)
        #expect(config.isRecentlyVisible)
        #expect(!MainSectionConfig(userDefaults: userDefaults).isShortcutVisible)
    }
}

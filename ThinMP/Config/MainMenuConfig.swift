//
//  MainMenuConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/11.
//

import Foundation

/// ライブラリメニューの並び順と表示 / 非表示
/// 並び順は MainMenu.rawValue の配列、表示 / 非表示は rawValue をキーにした Bool で保存している
struct MainMenuConfig {
    private let sortKey = "sort"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [sortKey: MainMenu.allCases.map { $0.rawValue }])
        userDefaults.register(defaults: Dictionary(uniqueKeysWithValues: MainMenu.allCases.map { ($0.rawValue, true) }))
    }

    /// 保存した並び順に無いメニュー(あとから追加されたもの)は末尾に足し、知らない値は捨てる
    /// 同じメニューが 2 回保存されていたら最初の位置だけ残す(ForEach の id が重複しないように)
    func load() -> [MainMenuSetting] {
        let stored = (userDefaults.array(forKey: sortKey) as? [String] ?? []).compactMap { MainMenu(rawValue: $0) }.uniqued()
        let menus = stored + MainMenu.allCases.filter { !stored.contains($0) }

        return menus.map { MainMenuSetting(menu: $0, isVisible: userDefaults.bool(forKey: $0.rawValue)) }
    }

    func save(_ menus: [MainMenuSetting]) {
        userDefaults.set(menus.map { $0.menu.rawValue }, forKey: sortKey)

        for setting in menus {
            userDefaults.set(setting.isVisible, forKey: setting.menu.rawValue)
        }
    }
}

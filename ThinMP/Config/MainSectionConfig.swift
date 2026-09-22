//
//  MainSectionConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import Foundation

/// メインページのショートカット / 最近追加セクションの表示 / 非表示
struct MainSectionConfig {
    private let shortcutKey = "shortcut"
    private let recentlyKey = "recently"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [
            shortcutKey: true,
            recentlyKey: true,
        ])
    }

    var isShortcutVisible: Bool {
        get { userDefaults.bool(forKey: shortcutKey) }
        nonmutating set { userDefaults.set(newValue, forKey: shortcutKey) }
    }

    var isRecentlyVisible: Bool {
        get { userDefaults.bool(forKey: recentlyKey) }
        nonmutating set { userDefaults.set(newValue, forKey: recentlyKey) }
    }
}

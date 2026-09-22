//
//  MainSectionConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import Foundation

/// メインページのショートカット / 最近追加セクションの表示 / 非表示
class MainSectionConfig {
    private let SHORTCUT = "shortcut"
    private let RECENTLY = "recently"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [
            SHORTCUT: true,
            RECENTLY: true,
        ])
    }

    var isShortcutVisible: Bool {
        get { userDefaults.bool(forKey: SHORTCUT) }
        set { userDefaults.set(newValue, forKey: SHORTCUT) }
    }

    var isRecentlyVisible: Bool {
        get { userDefaults.bool(forKey: RECENTLY) }
        set { userDefaults.set(newValue, forKey: RECENTLY) }
    }
}

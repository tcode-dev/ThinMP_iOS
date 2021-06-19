//
//  MainSectionConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import Foundation

class MainSectionConfig {
    private let KEY_SHORTCUT = "shortcut"
    private let KEY_RECENTLY = "recently"

    init() {
        UserDefaults.standard.register(defaults: [
            KEY_SHORTCUT: true,
            KEY_RECENTLY: true
        ])
    }

    func getShortcut() -> MenuModel {
        return MenuModel(primaryText: "Shortcut", visibility: UserDefaults.standard.bool(forKey: KEY_SHORTCUT))
    }

    func getRecently() -> MenuModel {
        return MenuModel(primaryText: "RecentlyAdded", visibility: UserDefaults.standard.bool(forKey: KEY_RECENTLY))
    }

    func setShortcutVisibility(value: Bool) {
        UserDefaults.standard.set(value, forKey: KEY_SHORTCUT)
    }

    func setRecentlyVisibility(value: Bool) {
        UserDefaults.standard.set(value, forKey: KEY_RECENTLY)
    }
}

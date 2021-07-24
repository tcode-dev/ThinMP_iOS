//
//  MainSectionConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import Foundation

class MainSectionConfig {
    private let SHORTCUT = "shortcut"
    private let RECENTLY = "recently"

    init() {
        UserDefaults.standard.register(defaults: [
            SHORTCUT: true,
            RECENTLY: true,
        ])
    }

    func getShortcut() -> MenuModel {
        return MenuModel(primaryText: LabelConstant.shortcut, visibility: UserDefaults.standard.bool(forKey: SHORTCUT))
    }

    func getRecently() -> MenuModel {
        return MenuModel(primaryText: LabelConstant.recentlyAdded, visibility: UserDefaults.standard.bool(forKey: RECENTLY))
    }

    func setShortcutVisibility(value: Bool) {
        UserDefaults.standard.set(value, forKey: SHORTCUT)
    }

    func setRecentlyVisibility(value: Bool) {
        UserDefaults.standard.set(value, forKey: RECENTLY)
    }
}

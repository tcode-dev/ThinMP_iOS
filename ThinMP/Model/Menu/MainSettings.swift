//
//  MainSettings.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

/// メインページの表示設定。MainService が Config から読み、編集ページから書き戻す
struct MainSettings: Equatable {
    var menus: [MainMenuSetting]
    var isShortcutVisible: Bool
    var isRecentlyVisible: Bool

    /// 読み込む前の値。何も表示しない
    static let empty = MainSettings(menus: [], isShortcutVisible: false, isRecentlyVisible: false)
}

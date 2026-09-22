//
//  MainMenuSetting.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

/// ライブラリメニュー 1 件分の表示設定。並び順は配列の順で持つ
struct MainMenuSetting: Identifiable, Equatable {
    let menu: MainMenu
    var visibility: Bool

    var id: MainMenu {
        return menu
    }
}

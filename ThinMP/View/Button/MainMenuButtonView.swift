//
//  MainMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/06/10.
//

import SwiftUI

/// メインページのライブラリメニュー 1 行。タップで対応する一覧ページへ
struct MainMenuButtonView: View {
    let menu: MainMenu

    var body: some View {
        NavigationLink(value: menu) {
            MenuRowView(label: menu.label)
        }
    }
}

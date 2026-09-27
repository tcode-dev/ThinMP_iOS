//
//  PlaylistDeleteButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/07/18.
//

import SwiftUI

/// プレイリストの削除ボタン。コンテキストメニューと、削除の確認ダイアログに置く
struct PlaylistDeleteButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(.removePlaylist, role: .destructive, action: action)
    }
}

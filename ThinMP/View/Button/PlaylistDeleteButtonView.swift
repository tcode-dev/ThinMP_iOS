//
//  PlaylistDeleteButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/07/18.
//

import SwiftUI

/// コンテキストメニューに置く、プレイリストの削除ボタン
struct PlaylistDeleteButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(role: .destructive, action: action) {
            Text(label: LabelConstant.removePlaylist)
        }
    }
}

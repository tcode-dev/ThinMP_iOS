//
//  ShortcutImageView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// ショートカットの画像。アーティストは丸、アルバム / プレイリストは角。セルと編集行で共有する
struct ShortcutImageView: View {
    let shortcut: ShortcutModel
    let size: CGFloat

    var body: some View {
        if case .artist = shortcut.target {
            CircleImageView(artwork: shortcut.artwork, size: size)
        } else {
            SquareImageView(artwork: shortcut.artwork, size: size)
        }
    }
}

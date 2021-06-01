//
//  ShortcutCellView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

struct ShortcutCellView: View {
    var shortcut: ShortcutModel
    var size: CGFloat

    var body: some View {
        VStack(){
            if (shortcut.type == ShortcutType.ARTIST.rawValue) {
                CircleImageView(artwork: shortcut.artwork, size: size)
            } else {
                SquareImageView(artwork: shortcut.artwork, size: size)
            }
            PrimaryTextView(shortcut.primaryText)
            SecondaryTextView(shortcut.secondaryText)
        }
    }
}

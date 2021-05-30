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
//            SquareImageView(artwork: self.album.artwork, size: size)
            PrimaryTextView(shortcut.primaryText)
            SecondaryTextView(shortcut.secondaryText)
        }
    }
}

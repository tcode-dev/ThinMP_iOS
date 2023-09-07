//
//  ShortcutRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/24.
//

import SwiftUI

struct ShortcutRowView: View {
    private let size: CGFloat = 40

    let shortcut: ShortcutModel

    var body: some View {
        HStack {
            if shortcut.type == ShortcutType.ARTIST.rawValue {
                CircleImageView(artwork: shortcut.artwork, size: size)
            } else {
                SquareImageView(artwork: shortcut.artwork, size: size)
            }
            VStack(alignment: .leading) {
                PrimaryTextView(shortcut.primaryText)
                SecondaryTextView(shortcut.secondaryText)
            }
            Spacer()
        }
        .frame(height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.Padding.tiny)
        .padding(.trailing, StyleConstant.Padding.tiny)
    }
}

//
//  ShortcutCellView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

struct ShortcutCellView: View {
    let shortcut: ShortcutModel
    let size: CGFloat

    var body: some View {
        VStack {
            ShortcutImageView(shortcut: shortcut, size: size)
            PrimaryTextView(shortcut.primaryText)
            SecondaryTextView(label: shortcut.target.type.label)
        }
        .padding(StyleConstant.Padding.small)
    }
}

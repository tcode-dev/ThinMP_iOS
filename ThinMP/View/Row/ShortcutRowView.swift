//
//  ShortcutRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/24.
//

import SwiftUI

struct ShortcutRowView: View {
    let shortcut: ShortcutModel

    var body: some View {
        HStack {
            ShortcutImageView(shortcut: shortcut, size: StyleConstant.thumbnail)
            VStack(alignment: .leading) {
                PrimaryTextView(shortcut.primaryText)
                SecondaryTextView(label: shortcut.target.type.label)
            }
            Spacer()
        }
        .rowStyle()
    }
}

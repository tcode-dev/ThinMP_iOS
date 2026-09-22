//
//  EditModifier.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// テキスト入力中だけ、タップでキーボードを閉じられるようにする
struct EditModifier: ViewModifier {
    let editing: Bool

    func body(content: Content) -> some View {
        if editing {
            content.onTapGesture { UIApplication.shared.endEditing() }
        } else {
            content
        }
    }
}

//
//  Text+Label.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

extension Text {
    /// Localizable.strings のキー(LabelConstant)から作る
    /// String を渡すと翻訳されずにそのまま出るので、ラベルはこれを通す
    init(label: String) {
        self.init(LocalizedStringKey(label))
    }
}

//
//  Optional+OrUnknown.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import Foundation

extension String? {
    /// nil か空文字なら「不明」の表示用文字列。曲名やアーティスト名が取れないときに使う
    var orUnknown: String {
        guard let text = self, !text.isEmpty else {
            return NSLocalizedString(LabelConstant.unknown, comment: "")
        }

        return text
    }
}

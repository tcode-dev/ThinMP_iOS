//
//  StyleConstant.swift
//  ThinMP
//
//  Created by tk on 2021/07/03.
//

import SwiftUI

enum StyleConstant {
    /// iPad は余白と比率を少し変える
    @MainActor static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static let button: CGFloat = 50
    /// 行とミニプレイヤーに並べるアートワークの 1 辺
    static let thumbnail: CGFloat = 40
    static let cornerRadius: CGFloat = 4
    static let dividerHeight: CGFloat = 0.5
    /// 背景に敷くアートワークのぼかし。アーティスト詳細のヒーローと再生画面で揃える
    static let artworkBlurRadius: CGFloat = 10

    enum Height {
        static let row: CGFloat = 50
        static let header: CGFloat = 60
    }

    enum Padding {
        static let tiny: CGFloat = 5
        static let small: CGFloat = 10
        static let medium: CGFloat = 15
        static let large: CGFloat = 20
    }

    enum Grid {
        static let minSpanCount: Int = 2
        static let spanBaseSize: Int = 200
    }
}

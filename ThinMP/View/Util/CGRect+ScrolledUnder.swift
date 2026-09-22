//
//  CGRect+ScrolledUnder.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

extension CGRect {
    /// 一覧 / ヒーローの先頭がナビゲーションバーの下に潜り込んだか
    /// ナビゲーションバーの背景とタイトル、ヒーローのタイトルの表示を切り替えるのに使う
    /// top はナビゲーションバーの下端。ページ遷移直後は位置を取得できていないので、CGRect.zero は潜り込んでいない扱いにする
    func isScrolledUnder(top: CGFloat) -> Bool {
        if self == CGRect.zero {
            return false
        }

        return origin.y - top < 0
    }
}

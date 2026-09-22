//
//  GeometryProxy+HeroSize.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

extension GeometryProxy {
    /// 詳細ページ先頭のヒーロー画像の 1 辺
    /// 縦向きなら幅いっぱい、横向きならセーフエリア込みの高さいっぱいの正方形。回転すると GeometryReader が再評価するので追従する
    var heroSize: CGFloat {
        return min(size.width, size.height + safeAreaInsets.top + safeAreaInsets.bottom)
    }
}

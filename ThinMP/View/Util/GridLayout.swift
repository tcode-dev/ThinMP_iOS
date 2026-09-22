//
//  GridLayout.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 画面幅から LazyVGrid の列とセルの大きさを決める。アルバムとショートカットのグリッドで共有する
/// 列の間隔は Padding.large で、右端の列だけ間隔を持たない
struct GridLayout {
    let columns: [GridItem]
    let cellSize: CGFloat

    init(width: CGFloat) {
        let count = max(Int(width) / StyleConstant.Grid.spanBaseSize, StyleConstant.Grid.minSpanCount)
        let size = (width - StyleConstant.Padding.large * CGFloat(count + 1)) / CGFloat(count)
        var columns = [GridItem](repeating: GridItem(.fixed(size), spacing: StyleConstant.Padding.large), count: count - 1)

        columns.append(GridItem(.fixed(size), spacing: 0))

        self.columns = columns
        cellSize = size
    }
}

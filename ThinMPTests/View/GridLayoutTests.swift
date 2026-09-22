//
//  GridLayoutTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import SwiftUI
import Testing
@testable import ThinMP

struct GridLayoutTests {
    /// 幅が spanBaseSize の 2 倍未満でも minSpanCount 列は確保する
    @Test
    func narrowWidthStillGetsMinimumColumns() {
        let layout = GridLayout(width: 390)

        #expect(layout.columns.count == StyleConstant.Grid.minSpanCount)
        // 幅から列間 (列数 + 1) 分の余白を引いて等分する
        #expect(layout.cellSize == (390 - StyleConstant.Padding.large * 3) / 2)
    }

    /// 幅が広ければ spanBaseSize ごとに 1 列増える
    @Test
    func wideWidthAddsColumns() {
        let layout = GridLayout(width: 1024)

        #expect(layout.columns.count == 5)
        #expect(layout.cellSize == (1024 - StyleConstant.Padding.large * 6) / 5)
    }

    /// 列間は Padding.large、右端の列だけ間隔を持たない
    @Test
    func onlyTheLastColumnHasNoSpacing() {
        let layout = GridLayout(width: 1024)

        #expect(layout.columns.dropLast().allSatisfy { $0.spacing == StyleConstant.Padding.large })
        #expect(layout.columns.last?.spacing == 0)
    }
}

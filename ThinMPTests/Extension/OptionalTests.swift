//
//  OptionalTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Foundation
import Testing
@testable import ThinMP

@MainActor
struct OptionalTests {
    @Test
    func orUnknownKeepsTheText() {
        let text: String? = "Song"

        #expect(text.orUnknown == "Song")
    }

    /// 空白だけの文字列は「不明」にしない。ライブラリがそう持っているならそのまま出す
    @Test
    func orUnknownKeepsAStringOfSpaces() {
        let text: String? = " "

        #expect(text.orUnknown == " ")
    }

    @Test
    func orUnknownFallsBackForNilAndEmpty() {
        let none: String? = nil
        let empty: String? = ""
        let unknown = NSLocalizedString(LabelConstant.unknown, comment: "")

        #expect(!unknown.isEmpty)
        #expect(unknown != LabelConstant.unknown)
        #expect(none.orUnknown == unknown)
        #expect(empty.orUnknown == unknown)
    }
}

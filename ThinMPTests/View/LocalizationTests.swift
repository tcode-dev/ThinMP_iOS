//
//  LocalizationTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Foundation
import Testing
@testable import ThinMP

struct LocalizationTests {
    private func format(_ key: String, language: String, _ arguments: CVarArg...) throws -> String {
        let path = try #require(Bundle.main.path(forResource: language, ofType: "lproj"))
        let bundle = try #require(Bundle(path: path))

        return String(format: NSLocalizedString(key, bundle: bundle, comment: ""), locale: Locale(identifier: language), arguments: arguments)
    }

    /// 英語は Localizable.stringsdict で単数 / 複数を出し分ける
    @Test
    func albumsAndSongsCountUsesSingularForOne() throws {
        #expect(try format(LabelConstant.albumsAndSongsCount, language: "en", 1, 1) == "1 album, 1 song")
        #expect(try format(LabelConstant.albumsAndSongsCount, language: "en", 2, 1) == "2 albums, 1 song")
        #expect(try format(LabelConstant.albumsAndSongsCount, language: "en", 0, 12) == "0 albums, 12 songs")
    }

    /// 日本語は単数 / 複数が無いので Localizable.strings のまま
    @Test
    func albumsAndSongsCountInJapanese() throws {
        #expect(try format(LabelConstant.albumsAndSongsCount, language: "ja", 1, 12) == "1枚のアルバム、12曲")
    }
}

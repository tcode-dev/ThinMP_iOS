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
    private func string(_ resource: LocalizedStringResource, language: String) -> String {
        var resource = resource

        resource.locale = Locale(identifier: language)

        return String(localized: resource)
    }

    /// 英語は String Catalog の複数形で単数 / 複数を出し分ける
    @Test
    func albumsAndSongsCountUsesSingularForOne() {
        #expect(string(.albumsAndSongsCount(albums: 1, songs: 1), language: "en") == "1 album, 1 song")
        #expect(string(.albumsAndSongsCount(albums: 2, songs: 1), language: "en") == "2 albums, 1 song")
        #expect(string(.albumsAndSongsCount(albums: 0, songs: 12), language: "en") == "0 albums, 12 songs")
    }

    /// 日本語は単数 / 複数が無いので 1 つの文言
    @Test
    func albumsAndSongsCountInJapanese() {
        #expect(string(.albumsAndSongsCount(albums: 1, songs: 12), language: "ja") == "1枚のアルバム、12曲")
    }
}

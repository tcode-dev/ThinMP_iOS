//
//  MainSectionConfigTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Foundation
import Testing
@testable import ThinMP

/// MainSectionConfig と UserDefaults の往復
struct MainSectionConfigTests {
    @Test
    func sectionVisibilityDefaultsToTrueAndRoundTrips() {
        let userDefaults = UserDefaults.empty()
        let config = MainSectionConfig(userDefaults: userDefaults)

        #expect(config.isShortcutVisible)
        #expect(config.isRecentlyVisible)

        config.isShortcutVisible = false

        #expect(!config.isShortcutVisible)
        #expect(config.isRecentlyVisible)
        #expect(!MainSectionConfig(userDefaults: userDefaults).isShortcutVisible)
    }
}

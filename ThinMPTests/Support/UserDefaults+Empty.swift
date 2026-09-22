//
//  UserDefaults+Empty.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Foundation

extension UserDefaults {
    /// テストごとに空の UserDefaults。suite 名を毎回変えるので他のテストと混ざらない
    static func empty() -> UserDefaults {
        let name = "ThinMPTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: name)!

        userDefaults.removePersistentDomain(forName: name)

        return userDefaults
    }
}

//
//  PlayerConfigTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Foundation
import MediaPlayer
import Testing
@testable import ThinMP

struct PlayerConfigTests {
    /// テストごとに空の UserDefaults
    private func makeUserDefaults() -> UserDefaults {
        let name = "PlayerConfigTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: name)!

        userDefaults.removePersistentDomain(forName: name)

        return userDefaults
    }

    @Test
    func defaultsToNoRepeatAndNoShuffle() {
        let config = PlayerConfig(userDefaults: makeUserDefaults())

        #expect(config.repeatMode == .none)
        #expect(config.shuffleMode == .off)
    }

    @Test
    func modesRoundTripAcrossInstances() {
        let userDefaults = makeUserDefaults()
        let config = PlayerConfig(userDefaults: userDefaults)

        config.repeatMode = .one
        config.shuffleMode = .songs

        #expect(PlayerConfig(userDefaults: userDefaults).repeatMode == .one)
        #expect(PlayerConfig(userDefaults: userDefaults).shuffleMode == .songs)
    }

    /// リリース済みのアプリが書いた形式: "repeat" / "shuffle" に rawValue の Int
    @Test
    func readsLegacyStoredFormat() {
        let userDefaults = makeUserDefaults()

        userDefaults.set(MPMusicRepeatMode.all.rawValue, forKey: "repeat")
        userDefaults.set(MPMusicShuffleMode.songs.rawValue, forKey: "shuffle")

        let config = PlayerConfig(userDefaults: userDefaults)

        #expect(config.repeatMode == .all)
        #expect(config.shuffleMode == .songs)
    }
}

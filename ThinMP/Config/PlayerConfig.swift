//
//  PlayerConfig.swift
//  ThinMP
//
//  Created by tk on 2020/06/08.
//

import Foundation
import MediaPlayer

/// リピートとシャッフルの設定。アプリを再起動しても引き継ぐ
struct PlayerConfig {
    private let repeatKey = "repeat"
    private let shuffleKey = "shuffle"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [
            repeatKey: MPMusicRepeatMode.none.rawValue,
            shuffleKey: MPMusicShuffleMode.off.rawValue,
        ])
    }

    var repeatMode: MPMusicRepeatMode {
        get { MPMusicRepeatMode(rawValue: userDefaults.integer(forKey: repeatKey)) ?? .none }
        nonmutating set { userDefaults.set(newValue.rawValue, forKey: repeatKey) }
    }

    var shuffleMode: MPMusicShuffleMode {
        get { MPMusicShuffleMode(rawValue: userDefaults.integer(forKey: shuffleKey)) ?? .off }
        nonmutating set { userDefaults.set(newValue.rawValue, forKey: shuffleKey) }
    }
}

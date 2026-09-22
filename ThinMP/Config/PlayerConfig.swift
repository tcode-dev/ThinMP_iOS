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
    private let REPEAT = "repeat"
    private let SHUFFLE = "shuffle"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [
            REPEAT: MPMusicRepeatMode.none.rawValue,
            SHUFFLE: MPMusicShuffleMode.off.rawValue,
        ])
    }

    var repeatMode: MPMusicRepeatMode {
        get { MPMusicRepeatMode(rawValue: userDefaults.integer(forKey: REPEAT)) ?? .none }
        nonmutating set { userDefaults.set(newValue.rawValue, forKey: REPEAT) }
    }

    var shuffleMode: MPMusicShuffleMode {
        get { MPMusicShuffleMode(rawValue: userDefaults.integer(forKey: SHUFFLE)) ?? .off }
        nonmutating set { userDefaults.set(newValue.rawValue, forKey: SHUFFLE) }
    }
}

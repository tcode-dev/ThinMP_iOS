//
//  PlayerConfig.swift
//  ThinMP
//
//  Created by tk on 2020/06/08.
//

import Foundation
import MediaPlayer

class PlayerConfig {
    private let KEY_REPEAT = "repeat"
    private let KEY_SHUFFLE = "shuffle"

    init() {
        UserDefaults.standard.register(defaults: [KEY_REPEAT: MPMusicRepeatMode.none.rawValue])
        UserDefaults.standard.register(defaults: [KEY_SHUFFLE: MPMusicShuffleMode.off.rawValue])
    }

    func setRepeat(value: MPMusicRepeatMode) {
        UserDefaults.standard.set(value.rawValue, forKey: KEY_REPEAT)
    }

    func getRepeat() -> MPMusicRepeatMode {
        return MPMusicRepeatMode(rawValue: UserDefaults.standard.integer(forKey: KEY_REPEAT)) ?? MPMusicRepeatMode.none
    }

    func setShuffle(value: MPMusicShuffleMode) {
        UserDefaults.standard.set(value.rawValue, forKey: KEY_SHUFFLE)
    }

    func getShuffle() -> MPMusicShuffleMode {
        return MPMusicShuffleMode(rawValue: UserDefaults.standard.integer(forKey: KEY_SHUFFLE)) ?? MPMusicShuffleMode.off
    }
}

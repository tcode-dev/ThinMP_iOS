//
//  PlayerConfig.swift
//  ThinMP
//
//  Created by tk on 2020/06/08.
//

import Foundation
import MediaPlayer

class PlayerConfig {
    private let REPEAT = "repeat"
    private let SHUFFLE = "shuffle"

    init() {
        UserDefaults.standard.register(defaults: [REPEAT: MPMusicRepeatMode.none.rawValue])
        UserDefaults.standard.register(defaults: [SHUFFLE: MPMusicShuffleMode.off.rawValue])
    }

    func setRepeat(value: MPMusicRepeatMode) {
        UserDefaults.standard.set(value.rawValue, forKey: REPEAT)
    }

    func getRepeat() -> MPMusicRepeatMode {
        return MPMusicRepeatMode(rawValue: UserDefaults.standard.integer(forKey: REPEAT)) ?? MPMusicRepeatMode.none
    }

    func setShuffle(value: MPMusicShuffleMode) {
        UserDefaults.standard.set(value.rawValue, forKey: SHUFFLE)
    }

    func getShuffle() -> MPMusicShuffleMode {
        return MPMusicShuffleMode(rawValue: UserDefaults.standard.integer(forKey: SHUFFLE)) ?? MPMusicShuffleMode.off
    }
}

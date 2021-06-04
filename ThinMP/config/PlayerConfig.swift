//
//  PlayerConfig.swift
//  ThinMP
//
//  Created by tk on 2020/06/08.
//

import Foundation

class PlayerConfig {
    let KEY_REPEAT = "repeat"
    let KEY_SHUFFLE = "shuffle"

    init() {
        UserDefaults.standard.register(defaults: [KEY_REPEAT : MusicPlayer.REPEAT_OFF])
        UserDefaults.standard.register(defaults: [KEY_SHUFFLE : MusicPlayer.SHUFFLE_OFF])
    }

    func setRepeat(value: Int) {
        UserDefaults.standard.set(value, forKey: KEY_REPEAT)
    }

    func getRepeat() -> Int {
        return UserDefaults.standard.integer(forKey: KEY_REPEAT)
    }

    func setShuffle(shuffle: Bool) {
        UserDefaults.standard.set(shuffle, forKey: KEY_SHUFFLE)
    }

    func getShuffle() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_SHUFFLE)
    }
}

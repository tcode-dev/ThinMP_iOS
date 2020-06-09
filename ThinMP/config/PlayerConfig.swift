//
//  PlayerConfig.swift
//  ThinMP
//
//  Created by tk on 2020/06/08.
//

import Foundation

class PlayerConfig {
    let KEY_REPEAT = "repeat"

    init() {
        UserDefaults.standard.register(defaults: [self.KEY_REPEAT : MusicPlayer.REPEAT_OFF])
    }

    func setRepeat(value: Int) {
        UserDefaults.standard.set(value, forKey: self.KEY_REPEAT)
    }

    func getRepeat() -> Int {
        return UserDefaults.standard.integer(forKey: self.KEY_REPEAT)
    }
}

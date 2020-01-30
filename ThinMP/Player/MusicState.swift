//
//  MusicState.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import MediaPlayer

class MusicState: ObservableObject {
    // ミニプレイヤーを表示するか
    @Published var isActive: Bool = false
    // 再生中か
    @Published var isPlaying: Bool = false
    // 曲
    @Published var song: MPMediaItemCollection?
    
    func start(song: MPMediaItemCollection) {
        self.song = song
        isActive = true
        isPlaying = true
    }
    
    func restart() {
        isPlaying = true
    }

    func stop() {
        isPlaying = false
    }
}

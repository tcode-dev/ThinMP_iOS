//
//  PlayPauseButtonView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 再生中なら一時停止、それ以外なら再生のボタン。ミニプレイヤーと再生画面で共有する
struct PlayPauseButtonView: View {
    @Environment(MusicPlayer.self) private var musicPlayer

    let size: CGFloat

    var body: some View {
        if musicPlayer.isPlaying {
            Button(action: musicPlayer.pause) {
                ButtonImageView(image: .pauseButton, label: .pause, size: size)
            }
        } else {
            Button(action: musicPlayer.play) {
                ButtonImageView(image: .playButton, label: .play, size: size)
            }
        }
    }
}

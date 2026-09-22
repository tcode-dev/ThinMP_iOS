//
//  PlayPauseButtonView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 再生中なら一時停止、それ以外なら再生のボタン。ミニプレイヤーと再生画面で共有する
struct PlayPauseButtonView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    let size: CGFloat

    var body: some View {
        if musicPlayer.isPlaying {
            Button(action: musicPlayer.pause) {
                ButtonImageView(name: "PauseButton", size: size)
            }
        } else {
            Button(action: musicPlayer.play) {
                ButtonImageView(name: "PlayButton", size: size)
            }
        }
    }
}

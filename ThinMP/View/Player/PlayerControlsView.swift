//
//  PlayerControlsView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 前の曲 / 再生・一時停止 / 次の曲
struct PlayerControlsView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    var body: some View {
        HStack {
            Spacer()
            Button(action: musicPlayer.prev) {
                ButtonImageView(name: "PrevButton", size: 88)
            }
            Spacer()
            PlayPauseButtonView(size: 100)
            Spacer()
            Button(action: musicPlayer.next) {
                ButtonImageView(name: "NextButton", size: 88)
            }
            Spacer()
        }
    }
}

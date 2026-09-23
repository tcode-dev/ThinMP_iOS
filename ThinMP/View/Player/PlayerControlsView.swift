//
//  PlayerControlsView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 前の曲 / 再生・一時停止 / 次の曲
struct PlayerControlsView: View {
    private let sideButtonSize: CGFloat = 88
    private let playPauseButtonSize: CGFloat = 100

    @EnvironmentObject private var musicPlayer: MusicPlayer

    var body: some View {
        HStack {
            Spacer()
            Button(action: musicPlayer.prev) {
                ButtonImageView(name: "PrevButton", size: sideButtonSize)
            }
            Spacer()
            PlayPauseButtonView(size: playPauseButtonSize)
            Spacer()
            Button(action: musicPlayer.next) {
                ButtonImageView(name: "NextButton", size: sideButtonSize)
            }
            Spacer()
        }
    }
}

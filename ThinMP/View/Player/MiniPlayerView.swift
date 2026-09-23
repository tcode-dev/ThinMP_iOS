//
//  MiniPlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import SwiftUI

struct MiniPlayerView: View {
    private let buttonImageSize: CGFloat = 40
    private let buttonSize: CGFloat = 60

    @EnvironmentObject private var musicPlayer: MusicPlayer
    @State private var isPlayerPresented: Bool = false

    let bottom: CGFloat
    /// 再生画面を閉じたときに呼ばれる(一覧の再読み込みなど)
    var onPlayerDismiss: () -> Void = {}

    var body: some View {
        VStack {
            if musicPlayer.isActive {
                HStack {
                    Button(action: {
                        isPlayerPresented = true
                    }) {
                        HStack {
                            SquareImageView(artwork: musicPlayer.song?.artwork, size: StyleConstant.thumbnail)
                            PrimaryTextView(musicPlayer.song?.primaryText)
                            Spacer()
                        }
                    }
                    PlayPauseButtonView(size: buttonImageSize)
                        .frame(width: buttonSize, height: buttonSize)
                    Button(action: musicPlayer.next) {
                        ButtonImageView(image: .nextButton, label: LabelConstant.next, size: buttonImageSize)
                    }
                    .frame(width: buttonSize, height: buttonSize)
                }
                .frame(height: buttonSize)
                .padding(EdgeInsets(
                    top: 0,
                    leading: StyleConstant.Padding.large,
                    bottom: bottom,
                    trailing: 0
                ))
                .barBackground()
            }
        }
        // if の中に置くと、再生画面を開いている間に曲が無くなったとき(isActive が false)に画面ごと消える
        .sheet(isPresented: $isPlayerPresented) {
            PlayerView(onDismiss: onPlayerDismiss)
        }
    }
}

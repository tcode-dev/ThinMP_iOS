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

    @EnvironmentObject var musicPlayer: MusicPlayer
    @State private var isPlayerPresented: Bool = false

    let bottom: CGFloat
    /// 再生画面を閉じたときに呼ばれる(一覧の再読み込みなど)
    var onPlayerDismiss: () -> Void = {}

    var body: some View {
        VStack {
            if musicPlayer.isActive {
                HStack {
                    Button(action: {
                        isPlayerPresented.toggle()
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
                        ButtonImageView(name: "NextButton", size: buttonImageSize)
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
                .background(Color(UIColor.secondarySystemBackground))
                .border(Color(UIColor.systemGray5), width: 1)
                .sheet(isPresented: $isPlayerPresented) {
                    PlayerView(onDismiss: onPlayerDismiss).environmentObject(musicPlayer)
                }
            }
        }
    }
}

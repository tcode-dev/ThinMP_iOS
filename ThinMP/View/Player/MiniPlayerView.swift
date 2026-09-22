//
//  MiniPlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import SwiftUI

struct MiniPlayerView: View {
    private let imageSize: CGFloat = 40
    private let buttonSize: CGFloat = 60

    @EnvironmentObject var musicPlayer: MusicPlayer
    @State private var isFullScreen: Bool = false
    private let bottom: CGFloat
    private let callback: () -> Void

    init(bottom: CGFloat, callback: @escaping () -> Void = {}) {
        self.bottom = bottom
        self.callback = callback
    }

    var body: some View {
        VStack {
            if musicPlayer.isActive {
                HStack {
                    Button(action: {
                        isFullScreen.toggle()
                    }) {
                        HStack {
                            SquareImageView(artwork: musicPlayer.song?.artwork, size: imageSize)
                            PrimaryTextView(musicPlayer.song?.primaryText)
                            Spacer()
                        }
                    }
                    PlayPauseButtonView(size: imageSize)
                        .frame(width: buttonSize, height: buttonSize)
                    Button(action: musicPlayer.next) {
                        ButtonImageView(name: "NextButton", size: imageSize)
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
                .sheet(isPresented: $isFullScreen) {
                    PlayerView(callback: callback).environmentObject(musicPlayer)
                }
            } else {
                EmptyView()
            }
        }
    }
}

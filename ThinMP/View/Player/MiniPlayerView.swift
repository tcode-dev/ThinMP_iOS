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
    @State var isFullScreen: Bool = false
    let bottom: CGFloat

    var body: some View {
        VStack {
            if (musicPlayer.isActive) {
                HStack {
                    Button(action: {
                        self.isFullScreen.toggle()
                    }) {
                        HStack {
                            SquareImageView(artwork: musicPlayer.song?.artwork, size: imageSize)
                            PrimaryTextView(musicPlayer.song?.primaryText)
                            Spacer()
                        }
                    }
                    if (musicPlayer.isPlaying) {
                        Button(action: {
                            self.musicPlayer.doPause()
                        }) {
                            Image("PauseButton").renderingMode(.original).resizable().frame(width: imageSize, height: imageSize)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        
                        Button(action: {
                            self.musicPlayer.doNext()
                        }) {
                            Image("NextButton").renderingMode(.original).resizable().frame(width: imageSize, height: imageSize)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                    } else {
                        Button(action: {
                            self.musicPlayer.doPlay()
                        }) {
                            Image("PlayButton").renderingMode(.original).resizable().frame(width: imageSize, height: imageSize)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        Button(action: {
                            self.musicPlayer.doNext()
                        }) {
                            Image("NextButton").renderingMode(.original).resizable().frame(width: imageSize, height: imageSize)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                    }
                }
                .frame(height: buttonSize)
                .padding(EdgeInsets(
                    top: 0,
                    leading: StyleConstant.padding.medium,
                    bottom: bottom,
                    trailing: 0
                ))
                .background(Color(UIColor.secondarySystemBackground))
                .border(Color(UIColor.systemGray5), width: 1)
                .sheet(isPresented: $isFullScreen) {
                    PlayerView().environmentObject(self.musicPlayer)
                }
            } else {
                EmptyView()
            }
        }
    }
}

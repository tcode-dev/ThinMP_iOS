//
//  MiniPlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    @State var isFullScreen: Bool = false
    var bottom: CGFloat

    var imageSize: CGFloat = 40
    var buttonSize: CGFloat = 50

    var body: some View {
        Group {
            if (musicPlayer.isActive) {
                HStack {
                    Button(action: {
                        self.isFullScreen.toggle()
                    }) {
                        HStack {
                            SquareImageView(artwork: musicPlayer.song!.representativeItem?.artwork, size: imageSize)
                            PrimaryTextView(musicPlayer.song!.representativeItem?.title)
                            Spacer()
                        }
                    }
                    if (musicPlayer.isPlaying) {
                        Button(action: {
                            self.musicPlayer.pause()
                        }) {
                            Image("PauseButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        
                        Button(action: {
                            self.musicPlayer.playNext()
                        }) {
                            Image("NextButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        
                    } else {
                        Button(action: {
                            self.musicPlayer.play()
                        }) {
                            Image("PlayButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                        Button(action: {
                            self.musicPlayer.next()
                        }) {
                            Image("NextButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: buttonSize, height: buttonSize)
                    }
                }
                .frame(height: 50)
                .padding(EdgeInsets(
                    top: 0,
                    leading: 10,
                    bottom: bottom,
                    trailing: 0
                ))
                .background(Color(UIColor.secondarySystemBackground))
                .sheet(isPresented: $isFullScreen) {
                    PlayerView().environmentObject(self.musicPlayer)
                }
            } else {
                EmptyView()
            }
        }
    }
}

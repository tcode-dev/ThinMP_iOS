//
//  MiniPlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import SwiftUI


struct MiniPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    
    var size: CGFloat = 40
    
    var body: some View {
        Group {
            if (musicPlayer.isActive) {
                HStack {
                    SquareImageView(artwork: musicPlayer.song!.representativeItem?.artwork, size: size)
                    PrimaryTextView(musicPlayer.song!.representativeItem?.title)
                    Spacer()
                    if (musicPlayer.isPlaying) {
                        Button(action: {
                            self.musicPlayer.stop()
                        }) {
                            Image("StopButton").renderingMode(.original)
                        }
                        .frame(width: 50, height: 50)
                        
                        Button(action: {
                            self.musicPlayer.playNext()
                        }) {
                            Image("NextButton").renderingMode(.original)
                        }
                        .frame(width: 50, height: 50)
                        
                    } else {
                        Button(action: {
                            self.musicPlayer.play()
                        }) {
                            Image("PlayButton").renderingMode(.original)
                        }
                        .frame(width: 50, height: 50)
                        Button(action: {
                            self.musicPlayer.next()
                        }) {
                            Image("NextButton").renderingMode(.original)
                        }
                        .frame(width: 50, height: 50)
                    }
                }
                .frame(height: 50)
                .padding(.leading, 10)
                .background(Color.white)
            } else {
                EmptyView()
            }
        }
    }
}

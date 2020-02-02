//
//  PlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/02/01.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    @State var seeking: Bool = false
    let size: CGFloat = 220
    
    var body: some View {
        
        return GeometryReader { geometry in
            ZStack(alignment: .top) {
                ZStack {
                    Image(uiImage: self.musicPlayer.song?.representativeItem?.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 10.0)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: geometry.size.width).offset(y: 25)
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                VStack() {
                    SquareImageView(artwork: self.musicPlayer.song?.representativeItem?.artwork, size: self.size)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    VStack {
                        PrimaryTextView(self.musicPlayer.song?.representativeItem?.title)
                        SecondaryTextView(self.musicPlayer.song?.representativeItem?.artist)
                    }
                    Spacer()
                    HStack {
                        SecondaryTextView("\(self.musicPlayer.currentTime)").frame(width: 50).padding(.leading, 10)
                        Slider(value: self.$musicPlayer.currentSecond, in: 0...self.musicPlayer.durationSecond, step: 1, onEditingChanged: { changed in
                            if (self.musicPlayer.isPlaying && !self.seeking && changed) {
                                self.musicPlayer.stopProgress()
                                self.seeking = changed
                            }

                            self.musicPlayer.seek(time: self.musicPlayer.currentSecond)

                            if (self.musicPlayer.isPlaying && self.seeking && !changed) {
                                self.musicPlayer.startProgress()
                                self.seeking = changed
                            }
                        })
                            .accentColor(Color("#be88ef"))
                        SecondaryTextView("\(self.musicPlayer.durationTime)").frame(width: 50).padding(.trailing, 10)
                    }
                    Spacer()
                    if (self.musicPlayer.isPlaying) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.musicPlayer.playPrev()
                            }) {
                                Image("PrevButton").renderingMode(.original)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.pause()
                                self.musicPlayer.stopProgress()
                            }) {
                                Image("StopButton").renderingMode(.original)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.playNext()
                            }) {
                                Image("NextButton").renderingMode(.original)
                            }
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.musicPlayer.prev()
                            }) {
                                Image("PrevButton").renderingMode(.original)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.play()
                                self.musicPlayer.startProgress()
                            }) {
                                Image("PlayButton").renderingMode(.original)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.next()
                            }) {
                                Image("NextButton").renderingMode(.original)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                        }) {
                            Image("RepeatButton").renderingMode(.original)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image("ShuffleButton").renderingMode(.original)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image("FavoriteArtistOnButton").renderingMode(.original)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image("FavoriteSongOnButton").renderingMode(.original)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image("AddPlaylistButton").renderingMode(.original)
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            self.musicPlayer.immediateUpdateTime()
            
            if (self.musicPlayer.isPlaying) {
                self.musicPlayer.startProgress()
            }
        })
            .onDisappear(perform: {
                self.musicPlayer.stopProgress()
            })
    }
}

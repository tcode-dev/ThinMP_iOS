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
    
    func convertTime(time: TimeInterval) -> String {
        if (time < 1) {
            return "00:00"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute,.second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: time) ?? "00:00"
    }
    
    var body: some View {
        
        return GeometryReader { geometry in
            ZStack(alignment: .top) {
                ZStack {
                    Image(uiImage: self.musicPlayer.song?.representativeItem?.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 10.0)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom).frame(height: geometry.size.width).offset(y: 25)
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                VStack() {
                    Image(uiImage: self.musicPlayer.song?.representativeItem?.artwork?.image(at: CGSize(width: self.size, height: self.size)) ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                        .frame(width: self.size, height: self.size)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    VStack {
                        PrimaryTextView(self.musicPlayer.song?.representativeItem?.title)
                        SecondaryTextView(self.musicPlayer.song?.representativeItem?.artist)
                    }
                    Spacer()
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
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .accentColor(Color(.label))
                    HStack {
                        SecondaryTextView("\(self.convertTime(time: self.musicPlayer.currentSecond))").frame(width: 50).padding(.leading, 10)
                        Spacer()
                        SecondaryTextView("\(self.convertTime(time: self.musicPlayer.durationSecond))").frame(width: 50).padding(.trailing, 10)
                    }
                    Spacer()
                    if (self.musicPlayer.isPlaying) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.musicPlayer.playPrev()
                            }) {
                                Image("PrevButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.pause()
                                self.musicPlayer.stopProgress()
                            }) {
                                Image("PauseButton").renderingMode(.original).resizable().frame(width: 88, height: 88)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.playNext()
                            }) {
                                Image("NextButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                            }
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.musicPlayer.prev()
                            }) {
                                Image("PrevButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.play()
                                self.musicPlayer.startProgress()
                            }) {
                                Image("PlayButton").renderingMode(.original).resizable().frame(width: 88, height: 88)
                            }
                            Spacer()
                            Button(action: {
                                self.musicPlayer.next()
                            }) {
                                Image("NextButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack {
                        if (self.musicPlayer.isRepeatOff) {
                            Button(action: {
                                self.musicPlayer.changeRepeat()
                            }) {
                                Image("RepeatButton").renderingMode(.original).resizable().frame(width: 40, height: 40).opacity(0.5)
                            }
                            .frame(width: 44, height: 44)
                        } else if (self.musicPlayer.isRepeatAll) {
                            Button(action: {
                                self.musicPlayer.changeRepeat()
                            }) {
                                Image("RepeatButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            }
                            .frame(width: 44, height: 44)
                        } else if (self.musicPlayer.isRepeatOne) {
                            Button(action: {
                                self.musicPlayer.changeRepeat()
                            }) {
                                Image("RepeatOneButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            }
                            .frame(width: 44, height: 44)
                        }
                        Spacer()
                        Button(action: {
                        }) {
                            Image("ShuffleButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: 44, height: 44)
                        Spacer()
                        Button(action: {
                        }) {
                            Image("FavoriteArtistOnButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: 44, height: 44)
                        Spacer()
                        Button(action: {
                        }) {
                            Image("FavoriteSongOnButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: 44, height: 44)
                        Spacer()
                        Button(action: {
                        }) {
                            Image("PlaylistAddButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: 44, height: 44)
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

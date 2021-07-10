//
//  PlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/02/01.
//

import SwiftUI

struct PlayerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var musicPlayer: MusicPlayer

    @State var seeking: Bool = false
    @State private var showingPopup: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ZStack {
                    Image(uiImage: musicPlayer.song?.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 10.0)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom).frame(height: geometry.size.width).offset(y: 25)
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                VStack() {
                    Image(uiImage: musicPlayer.song?.artwork?.image(at: CGSize(width: 220, height: 220)) ?? UIImage(imageLiteralResourceName: "Song"))
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                        .frame(width: 220, height: 220)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    ZStack(alignment: .bottom) {
                        SecondaryTitleView(musicPlayer.song?.primaryText).frame(height: 50).offset(y: -10)
                        SecondaryTextView(musicPlayer.song?.secondaryText).frame(height: 25)
                    }.frame(height: 60)

                    Spacer()

                    Slider(value: $musicPlayer.currentSecond, in: 0...musicPlayer.durationSecond, step: 1, onEditingChanged: { changed in
                        if (musicPlayer.isPlaying && !seeking && changed) {
                            musicPlayer.stopProgress()
                            seeking = changed
                        }

                        musicPlayer.seek(time: musicPlayer.currentSecond)

                        if (musicPlayer.isPlaying && seeking && !changed) {
                            musicPlayer.startProgress()
                            seeking = changed
                        }
                    })
                    .padding(.leading, StyleConstant.padding.medium)
                    .padding(.trailing, StyleConstant.padding.medium)
                    .accentColor(Color(.label))

                    HStack {
                        SecondaryTextView("\(convertTime(time: musicPlayer.currentSecond))").frame(width: 50).padding(.leading, StyleConstant.padding.medium)
                        Spacer()
                        SecondaryTextView("\(convertTime(time: musicPlayer.durationSecond))").frame(width: 50).padding(.trailing, StyleConstant.padding.medium)
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            musicPlayer.doPrev()
                        }) {
                            Image("PrevButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                        }

                        Spacer()

                        if (musicPlayer.isPlaying) {
                            Button(action: {
                                musicPlayer.doPause()
                            }) {
                                Image("PauseButton").renderingMode(.original).resizable().frame(width: 88, height: 88)
                            }
                        } else {
                            Button(action: {
                                musicPlayer.doPlay()
                            }) {
                                Image("PlayButton").renderingMode(.original).resizable().frame(width: 88, height: 88)
                            }
                        }

                        Spacer()

                        Button(action: {
                            musicPlayer.doNext()
                        }) {
                            Image("NextButton").renderingMode(.original).resizable().frame(width: 72, height: 72)
                        }

                        Spacer()
                    }

                    Spacer()

                    HStack {
                        Button(action: {
                            musicPlayer.changeRepeat()
                        }) {
                            if (musicPlayer.isRepeatOff) {
                                Image("RepeatButton").renderingMode(.original).resizable().frame(width: 40, height: 40).opacity(0.5)
                            } else if (musicPlayer.isRepeatAll) {
                                Image("RepeatButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            } else if (musicPlayer.isRepeatOne) {
                                Image("RepeatOneButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            }
                        }
                        .frame(width: StyleConstant.button, height: StyleConstant.button)

                        Spacer()

                        Button(action: {
                            musicPlayer.shuffle()
                        }) {
                            if (musicPlayer.shuffleMode) {
                                Image("ShuffleButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            } else {
                                Image("ShuffleButton").renderingMode(.original).resizable().frame(width: 40, height: 40).opacity(0.5)
                            }
                        }
                        .frame(width: StyleConstant.button, height: StyleConstant.button)

                        Spacer()

                        Button(action: {
                            musicPlayer.favoriteArtist()
                        }) {
                            if (musicPlayer.isFavoriteArtist) {
                                Image("FavoriteArtistButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                            } else {
                                Image("FavoriteArtistButton").renderingMode(.original).resizable().frame(width: 40, height: 40).opacity(0.5)
                            }
                        }
                        .frame(width: StyleConstant.button, height: StyleConstant.button)

                        Spacer()

                        Button(action: {
                            musicPlayer.favoriteSong()
                        }) {
                            if (musicPlayer.isFavoriteSong) {
                                Image("FavoriteSongButton").renderingMode(.original).resizable().frame(width: 30, height: 30)
                            } else {
                                Image("FavoriteSongButton").renderingMode(.original).resizable().frame(width: 30, height: 30).opacity(0.5)
                            }
                        }
                        .frame(width: StyleConstant.button, height: StyleConstant.button)

                        Spacer()

                        Button(action: {
                            showingPopup.toggle()
                        }) {
                            Image("PlaylistAddButton").renderingMode(.original).resizable().frame(width: 40, height: 40)
                        }
                        .frame(width: StyleConstant.button, height: StyleConstant.button)
                    }
                    .padding(.horizontal, 30)

                    Spacer()
                }
                if (showingPopup) {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(songId: musicPlayer.song!.songId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
        }
        .onAppear(perform: {
            musicPlayer.immediateUpdateTime()
            
            if (musicPlayer.isPlaying) {
                musicPlayer.startProgress()
            }
        })
        .onDisappear(perform: {
            musicPlayer.stopProgress()
        })
        .onChange(of: scenePhase) { phase in
            if (phase == .background) {
                musicPlayer.setBackground(background: true)
            } else if (phase == .active) {
                musicPlayer.setBackground(background: false)
            }
        }
    }

    private func convertTime(time: TimeInterval) -> String {
        if (time < 1) {
            return "00:00"
        }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute,.second]
        formatter.zeroFormattingBehavior = [.pad]

        return formatter.string(from: time) ?? "00:00"
    }
}

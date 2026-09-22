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

    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?
    private let callback: () -> Void
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    init(callback: @escaping () -> Void = {}) {
        self.callback = callback
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width
            let height = geometry.size.height

            ZStack(alignment: .top) {
                ZStack {
                    Image(uiImage: musicPlayer.song?.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 10.0)

                    HeroGradientView().frame(height: geometry.size.width).offset(y: 25)
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        let imageSize = height * 0.3
                        Spacer()
                        SquareImageView(artwork: musicPlayer.song?.artwork, size: imageSize)
                            .padding(.top, size * 0.1)
                        Spacer()
                    }
                    .frame(height: height * 0.4)
                    VStack(spacing: 0) {
                        VStack(spacing: StyleConstant.Padding.tiny) {
                            TitleView(musicPlayer.song?.primaryText)
                            SecondaryTextView(musicPlayer.song?.secondaryText)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, StyleConstant.Padding.large)
                        Spacer()
                        Slider(value: $musicPlayer.currentSecond, in: 0 ... musicPlayer.durationSecond, step: 1, onEditingChanged: { editing in
                            if editing {
                                musicPlayer.beginSeek()
                            } else {
                                musicPlayer.endSeek()
                            }
                        })
                        .frame(height: StyleConstant.button)
                        .padding(.horizontal, isPad ? 40 : 30)
                        .accentColor(Color(.label))
                        HStack {
                            SecondaryTextView("\(convertTime(time: musicPlayer.currentSecond))").frame(width: 50, height: 20).padding(.leading, 40)
                            Spacer()
                            SecondaryTextView("\(convertTime(time: musicPlayer.durationSecond))").frame(width: 50, height: 20).padding(.trailing, 40)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                musicPlayer.prev()
                            }) {
                                ButtonImageView(name: "PrevButton", size: 88)
                            }
                            Spacer()
                            if musicPlayer.isPlaying {
                                Button(action: {
                                    musicPlayer.pause()
                                }) {
                                    ButtonImageView(name: "PauseButton", size: 100)
                                }
                            } else {
                                Button(action: {
                                    musicPlayer.play()
                                }) {
                                    ButtonImageView(name: "PlayButton", size: 100)
                                }
                            }
                            Spacer()
                            Button(action: {
                                musicPlayer.next()
                            }) {
                                ButtonImageView(name: "NextButton", size: 88)
                            }
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Button(action: {
                                musicPlayer.changeRepeat()
                            }) {
                                switch musicPlayer.repeatMode {
                                case .all:
                                    ButtonImageView(name: "RepeatButton", size: 50)
                                case .one:
                                    ButtonImageView(name: "RepeatOneButton", size: 50)
                                default:
                                    ButtonImageView(name: "RepeatButton", size: 50, dimmed: true)
                                }
                            }
                            .frame(width: StyleConstant.button, height: StyleConstant.button)
                            Spacer()
                            Button(action: {
                                musicPlayer.shuffle()
                            }) {
                                ButtonImageView(name: "ShuffleButton", size: 50, dimmed: !musicPlayer.isShuffle)
                            }
                            .frame(width: StyleConstant.button, height: StyleConstant.button)
                            Spacer()
                            Button(action: {
                                musicPlayer.favoriteArtist()
                            }) {
                                ButtonImageView(name: "FavoriteArtistButton", size: 50, dimmed: !musicPlayer.isFavoriteArtist)
                            }
                            .frame(width: StyleConstant.button, height: StyleConstant.button)
                            Spacer()
                            Button(action: {
                                musicPlayer.favoriteSong()
                            }) {
                                ButtonImageView(name: "FavoriteSongButton", size: 40, dimmed: !musicPlayer.isFavoriteSong)
                            }
                            .frame(width: StyleConstant.button, height: StyleConstant.button)
                            Spacer()
                            Button(action: {
                                playlistRegisterSongId = musicPlayer.song?.songId
                            }) {
                                ButtonImageView(name: "PlaylistAddButton", size: 50)
                            }
                            .frame(width: StyleConstant.button, height: StyleConstant.button)
                        }
                        .padding(.horizontal, isPad ? 50 : 30)
                        Spacer()
                    }
                    .frame(height: height * 0.6)
                }
            }
            .playlistRegisterPopup(songId: $playlistRegisterSongId, height: geometry.size.height)
        }
        .onAppear {
            musicPlayer.startProgress()
            musicPlayer.setFavorite()
        }
        .onDisappear {
            musicPlayer.stopProgress()
            callback()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                musicPlayer.stopProgress()
            } else if phase == .active {
                musicPlayer.startProgress()
            }
        }
    }

    /// 毎秒呼ばれるので formatter は使い回す
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()

        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        return formatter
    }()

    private func convertTime(time: TimeInterval) -> String {
        if time < 1 {
            return "00:00"
        }

        return Self.timeFormatter.string(from: time) ?? "00:00"
    }
}

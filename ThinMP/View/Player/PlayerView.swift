//
//  PlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/02/01.
//

import SwiftUI

/// ミニプレイヤーから開く全画面の再生画面
/// 表示中だけ MusicPlayer に再生位置の更新を頼み、閉じるときに onDismiss を呼ぶ
struct PlayerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var musicPlayer: MusicPlayer

    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    var onDismiss: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack(alignment: .top) {
                // 上半分の背景。アートワークをぼかして下端を背景色に溶かす
                ZStack {
                    Image(uiImage: musicPlayer.song?.artwork?.image(at: CGSize(width: width, height: width)) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 10.0)
                    HeroGradientView().frame(height: width).offset(y: 25)
                }
                .frame(width: width, height: width)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer()
                        SquareImageView(artwork: musicPlayer.song?.artwork, size: height * 0.3)
                            .padding(.top, width * 0.1)
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
                        PlayerSeekBarView()
                        Spacer()
                        PlayerControlsView()
                        Spacer()
                        PlayerOptionsView { playlistRegisterSongId = musicPlayer.song?.songId }
                        Spacer()
                    }
                    .frame(height: height * 0.6)
                }
            }
            .playlistRegisterPopup(songId: $playlistRegisterSongId, height: height)
        }
        .onAppear {
            musicPlayer.startProgress()
            musicPlayer.setFavorite()
        }
        .onDisappear {
            musicPlayer.stopProgress()
            onDismiss()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                musicPlayer.stopProgress()
            } else if phase == .active {
                musicPlayer.startProgress()
            }
        }
    }
}

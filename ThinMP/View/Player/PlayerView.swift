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
    /// 曲名とアーティスト名の 2 行分
    private let titleHeight: CGFloat = 50
    /// 画面の高さのうちアートワークの段が占める割合。残りが曲名と操作の段
    private let artworkAreaRate: CGFloat = 0.4
    /// アートワークの 1 辺。画面の高さに対する割合
    private let artworkSizeRate: CGFloat = 0.3
    /// アートワークの上の余白。画面の幅に対する割合
    private let artworkTopRate: CGFloat = 0.1
    /// 背景のグラデーションを下にずらして、ぼかしたアートワークの下端に被せる
    private let backgroundGradientOffset: CGFloat = 25

    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var musicPlayer: MusicPlayer

    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let onDismiss: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack(alignment: .top) {
                // 上半分の背景。アートワークをぼかして下端を背景色に溶かす
                ZStack {
                    Image(artwork: musicPlayer.song?.artwork, size: CGSize(width: width, height: width))
                        .resizable()
                        .scaledToFit()
                        .blur(radius: StyleConstant.artworkBlurRadius)
                    HeroGradientView().frame(height: width).offset(y: backgroundGradientOffset)
                }
                .frame(width: width, height: width)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer()
                        SquareImageView(artwork: musicPlayer.song?.artwork, size: height * artworkSizeRate)
                            .padding(.top, width * artworkTopRate)
                        Spacer()
                    }
                    .frame(height: height * artworkAreaRate)
                    VStack(spacing: 0) {
                        VStack(spacing: StyleConstant.Padding.tiny) {
                            TitleView(musicPlayer.song?.primaryText)
                            SecondaryTextView(musicPlayer.song?.secondaryText)
                        }
                        .frame(height: titleHeight)
                        .padding(.horizontal, StyleConstant.Padding.large)
                        Spacer()
                        PlayerSeekBarView()
                        Spacer()
                        PlayerControlsView()
                        Spacer()
                        PlayerOptionsView { playlistRegisterSongId = musicPlayer.song?.songId }
                        Spacer()
                    }
                    .frame(height: height * (1 - artworkAreaRate))
                }
            }
            .playlistRegisterPopup(songId: $playlistRegisterSongId, height: height)
        }
        .onAppear {
            musicPlayer.startProgress()
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

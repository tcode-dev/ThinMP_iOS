//
//  ScrollPageLayout.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 一覧 / 詳細ページ共通の骨組み
/// 自前のナビゲーションバーの下にスクロールする内容を重ね、下端にミニプレイヤーを出す
/// ナビゲーションバーと内容はセーフエリアや幅が要るので GeometryProxy を受け取って作る
struct ScrollPageLayout<NavBar: View, Content: View>: View {
    /// プレイリスト登録ポップアップを出している曲。ポップアップを持たないページは渡さない
    var playlistRegisterSongId: Binding<SongId?>?
    /// 再生画面を閉じたときに呼ばれる(一覧の再読み込みなど)
    var onPlayerDismiss: () -> Void = {}
    @ViewBuilder let navBar: (GeometryProxy) -> NavBar
    @ViewBuilder let content: (GeometryProxy) -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    navBar(geometry)
                    ScrollView {
                        VStack(alignment: .leading) {
                            content(geometry)
                        }
                    }
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom, callback: onPlayerDismiss)
            }
            .playlistRegisterPopup(songId: playlistRegisterSongId, height: geometry.size.height)
            .modifier(PageModifier())
        }
    }
}

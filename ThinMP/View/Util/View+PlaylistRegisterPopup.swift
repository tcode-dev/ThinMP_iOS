//
//  View+PlaylistRegisterPopup.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

extension View {
    /// プレイリスト登録ポップアップを画面全体に被せる
    /// songId が nil ならポップアップは閉じている。閉じるときは nil を書き戻す
    /// ポップアップを持たないページは nil を渡す
    func playlistRegisterPopup(songId: Binding<SongId?>?, height: CGFloat) -> some View {
        return overlay(alignment: .top) {
            if let songId, let id = songId.wrappedValue {
                PlaylistRegisterView(songId: id, height: height) { songId.wrappedValue = nil }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea(.container)
            }
        }
    }
}

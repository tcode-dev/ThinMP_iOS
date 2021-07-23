//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import MediaPlayer
import SwiftUI

// 登録、削除後にボタンを切り替えるために、初回と2回目以降の処理を分ける
// スクロールで画面表出した時にinitが呼ばれるのでinitでは処理しない
// 長押しで表出した時にbodyが呼ばれるのでbodyで処理する
struct FavoriteSongButtonView: View {
    @State private var initialDisplay: Bool = true
    @State private var exists: Bool = false

    private let songId: SongId
    private let callback: () -> Void

    init(songId: SongId, callback: @escaping () -> Void = {}) {
        self.songId = songId
        self.callback = callback
    }

    var body: some View {
        Group {
            if initialDisplay {
                // 初回描画時
                let register = FavoriteSongRegister()

                if !register.exists(songId: songId) {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            } else {
                // 2回目以降
                if !exists {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            }
        }
    }

    private func createAddButton() -> some View {
        return Button(action: {
            let register = FavoriteSongRegister()

            register.add(songId: songId)
            exists = true
            initialDisplay = false
            callback()
        }) {
            Text("AddFavorites")
        }
    }

    private func createRemoveButton() -> some View {
        Button(action: {
            let register = FavoriteSongRegister()

            register.delete(songId: songId)
            exists = false
            initialDisplay = false
            callback()
        }) {
            Text("RemoveFavorites")
        }
    }
}

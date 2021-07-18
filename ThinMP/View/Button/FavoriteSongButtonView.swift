//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import MediaPlayer
import SwiftUI

// 登録、削除後にボタンが切り替わらないので初回描画と2回目以降の描画で処理を分ける
// スクロールで画面表出した時にinitが呼ばれるのでinitでは処理しない
// 長押しで表出した時にbodyが呼ばれるのでbodyで処理する
struct FavoriteSongButtonView: View {
    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    private let songId: SongId
    private let callback: () -> Void

    init(songId: SongId, callback: @escaping () -> Void = {}) {
        self.songId = songId
        self.callback = callback
    }

    var body: some View {
        if !displayed {
            // 初回描画時
            let register = FavoriteSongRegister()

            if !register.exists(songId: songId) {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.add(songId: songId)
                    exists = true
                    displayed.toggle()
                    callback()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.delete(songId: songId)
                    exists = false
                    displayed.toggle()
                    callback()
                }) {
                    Text("RemoveFavorites")
                }
            }
        } else {
            // 2回目以降
            if !exists {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.add(songId: songId)
                    exists.toggle()
                    callback()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.delete(songId: songId)
                    exists.toggle()
                    callback()
                }) {
                    Text("RemoveFavorites")
                }
            }
        }
    }
}

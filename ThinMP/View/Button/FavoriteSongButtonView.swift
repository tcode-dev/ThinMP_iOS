//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

// 登録、削除後にボタンが切り替わらないので初回描画と2回目以降の描画で処理を分ける
// スクロールで画面表出した時にinitが呼ばれるのでinitでは処理しない
// 長押しで表出した時にbodyが呼ばれるのでbodyで処理する
struct FavoriteSongButtonView: View {
    private let ADD_TEXT: String = "お気に入りに追加"
    private let DELETE_TEXT: String = "お気に入りから削除"

    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        if (!displayed) {
            // 初回描画時
            let register = FavoriteSongRegister()

            if (!register.exists(persistentId: persistentId)) {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.add(persistentId: persistentId)
                    exists = true
                    displayed.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.delete(persistentId: persistentId)
                    exists = false
                    displayed.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        } else {
            // 2回目以降
            if (!exists) {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.add(persistentId: persistentId)
                    exists.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.delete(persistentId: persistentId)
                    exists.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        }
    }
}

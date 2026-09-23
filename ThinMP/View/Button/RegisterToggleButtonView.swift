//
//  RegisterToggleButtonView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// コンテキストメニューに置く、登録 / 解除を切り替えるボタン
/// お気に入り(アーティスト、曲)とショートカットで共有する
///
/// 登録済みかの問い合わせは body で行う。この View は一覧をスクロールしただけでも行ごとに init されるが、
/// body はコンテキストメニューを実際に開いたときにしか呼ばれないので、ストアを読むのはそのときだけで済む
/// 一度ボタンを押したあとは、toggle() が返した登録状態を isRegistered に持って問い合わせない
/// ただし再生画面など別の場所でも登録 / 解除できるので、メニューを開き直したら(onAppear)捨てて問い合わせ直す
struct RegisterToggleButtonView: View {
    /// nil はまだボタンを押していない状態。表示は exists() で決める
    @State private var isRegistered: Bool?

    let addLabel: String
    let removeLabel: String
    let exists: @MainActor () -> Bool
    /// 登録 / 解除を切り替えて、切り替えたあとの登録状態を返す
    let toggle: @MainActor () -> Bool
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}

    var body: some View {
        let registered = isRegistered ?? exists()

        Button(action: {
            isRegistered = toggle()
            onToggle()
        }) {
            Text(LocalizedStringKey(registered ? removeLabel : addLabel))
        }
        .onAppear {
            isRegistered = nil
        }
    }
}

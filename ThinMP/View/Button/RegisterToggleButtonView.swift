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
/// 一度ボタンを押したあとは、押した結果を isRegistered に持って問い合わせない
struct RegisterToggleButtonView: View {
    /// nil はまだボタンを押していない状態。表示は exists() で決める
    @State private var isRegistered: Bool?

    let addLabel: String
    let removeLabel: String
    let exists: @MainActor () -> Bool
    let add: @MainActor () -> Void
    let remove: @MainActor () -> Void
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}

    var body: some View {
        let registered = isRegistered ?? exists()

        Button(action: {
            if registered {
                remove()
            } else {
                add()
            }

            isRegistered = !registered
            onToggle()
        }) {
            Text(LocalizedStringKey(registered ? removeLabel : addLabel))
        }
    }
}

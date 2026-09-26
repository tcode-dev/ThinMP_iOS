//
//  RegisterToggleButtonView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// メニュー(ナビゲーションバーのメニュー、コンテキストメニュー)に置く、登録 / 解除を切り替えるボタン
/// お気に入り(アーティスト、曲)とショートカットで共有する
///
/// 表示する登録状態は body で毎回 exists() に問い合わせる
/// メニューは開き直しても中身の body を呼び直さず、onAppear も呼ばないので、
/// ストアの保存通知(SwiftDataStore.didSave)で body を作り直す。再生画面など別の場所での登録 / 解除もこれで反映される
struct RegisterToggleButtonView: View {
    /// 保存通知のたびに進めて body を作り直させる
    @State private var revision = 0

    let addLabel: LocalizedStringResource
    let removeLabel: LocalizedStringResource
    let exists: () -> Bool
    /// 登録 / 解除を切り替える
    let toggle: () -> Void
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}

    var body: some View {
        Button(isRegistered ? removeLabel : addLabel) {
            toggle()
            onToggle()
        }
        .onReceive(NotificationCenter.default.publisher(for: SwiftDataStore.didSave)) { _ in
            revision += 1
        }
    }

    /// body の中で revision を読むので、保存通知で revision が進むと問い合わせ直す
    private var isRegistered: Bool {
        _ = revision

        return exists()
    }
}

//
//  PermissionView.swift
//  ThinMP
//
//  Created by tk on 2023/09/11.
//

import MediaPlayer
import SwiftUI

/// ライブラリへのアクセスが許可されていれば content を、まだなら許可を求めて、拒否されたら設定への案内を出す
struct PermissionView<Content: View>: View {
    @State private var isAllowed = MPMediaLibrary.authorizationStatus() == .authorized
    @State private var isRequested = false

    @ViewBuilder let content: () -> Content

    var body: some View {
        if isAllowed {
            content()
        } else {
            VStack {
                if isRequested {
                    Text(LocalizedStringKey(LabelConstant.permission))
                        .padding(.horizontal, StyleConstant.Padding.large)
                }
            }
            .task {
                let status = await MPMediaLibrary.requestAuthorization()

                isAllowed = status == .authorized
                isRequested = true
            }
        }
    }
}

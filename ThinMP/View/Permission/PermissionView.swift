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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    @State private var status = MPMediaLibrary.authorizationStatus()

    @ViewBuilder let content: () -> Content

    var body: some View {
        if status == .authorized {
            content()
        } else {
            VStack(spacing: StyleConstant.Padding.large) {
                // 許可を求めている間(notDetermined)は何も出さない
                if status == .denied || status == .restricted {
                    Text(.permission)
                    Button(action: openSettings) {
                        Text(.openSettings)
                    }
                }
            }
            .padding(.horizontal, StyleConstant.Padding.large)
            .task {
                // 一度拒否されるとダイアログは二度と出ないので、求めるのはまだ決まっていないときだけ
                if status == .notDetermined {
                    status = await MPMediaLibrary.requestAuthorization()
                }
            }
            // 設定で許可してから戻ってきたときに読み直す
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    status = MPMediaLibrary.authorizationStatus()
                }
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            openURL(url)
        }
    }
}

//
//  ThinMP.swift
//  ThinMP
//
//  Created by tk on 2020/12/23.
//

import SwiftUI

@main
struct ThinMP: App {
    /// プレイヤーはアプリで 1 つ。body の中で生成すると再評価のたびに作り直されるので App が所有する
    @StateObject private var musicPlayer = MusicPlayer()

    init() {
        RealmToSwiftDataMigration().migrateIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            PermissionView {
                MainPageView().environmentObject(musicPlayer)
            }
        }
    }
}

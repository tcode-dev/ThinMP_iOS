//
//  ThinMP.swift
//  ThinMP
//
//  Created by tk on 2020/12/23.
//

import SwiftUI

@main
struct ThinMP: App {
    var body: some Scene {
        WindowGroup {
            PermissionView {
                MainPageView().environmentObject(MusicPlayer())
            }
        }
    }
}

//
//  PlaylistsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsNavBarView: View {
    private let TITLE: String = "Playlists"

    let top: CGFloat
    @Binding var rect: CGRect

    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            PlaylistsMenuButtonView()
        }
    }
}

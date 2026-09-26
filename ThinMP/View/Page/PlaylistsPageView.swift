//
//  PlaylistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsPageView: View {
    @State private var vm = PlaylistsViewModel()
    @State private var isScrolledUnder = false

    var body: some View {
        ScrollPageLayout(onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(titleKey: LabelConstant.playlists, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                EditButtonView {
                    PlaylistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            PlaylistListView(playlists: vm.playlists ?? []) { vm.delete(playlistId: $0) }
        }
        .onAppear {
            vm.load()
        }
    }
}

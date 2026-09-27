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
        ScrollPageLayout(onPlayerDismiss: { Task { await vm.load() } }) { geometry in
            ListNavBarView(title: .playlists, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                EditButtonView {
                    PlaylistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            PlaylistListView(playlists: vm.playlists ?? []) { playlistId in Task { await vm.delete(playlistId: playlistId) } }
        }
        .task {
            await vm.load()
        }
    }
}

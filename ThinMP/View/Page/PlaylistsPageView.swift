//
//  PlaylistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsPageView: View {
    @StateObject private var vm = PlaylistsViewModel()
    @State private var isScrolledUnder = false

    var body: some View {
        ScrollPageLayout(onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(title: LabelConstant.playlists, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                EditButtonView {
                    PlaylistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            LazyVStack(spacing: 0) {
                ForEach(vm.playlists) { playlist in
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: playlist.playlistId)) {
                        MediaRowView(media: playlist)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        PlaylistDeleteButtonView { vm.delete(playlistId: playlist.playlistId) }
                        ShortcutButtonView(target: .playlist(playlist.playlistId))
                    }
                    Divider()
                }
                .padding(.leading, StyleConstant.Padding.medium)
            }
        }
        .task {
            await vm.load().value
        }
    }
}

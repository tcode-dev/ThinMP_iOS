//
//  PlaylistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsPageView: View {
    @StateObject private var vm = PlaylistsViewModel()
    @State private var headerRect = CGRect.zero

    var body: some View {
        ScrollPageLayout(onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(title: LabelConstant.playlists, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                EditButtonView {
                    PlaylistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
            LazyVStack(spacing: 0) {
                ForEach(vm.playlists) { playlist in
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: playlist.playlistId)) {
                        MediaRowView(media: playlist)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        PlaylistDeleteButtonView(playlistId: playlist.playlistId) { vm.load() }
                        ShortcutButtonView(playlistId: playlist.playlistId)
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

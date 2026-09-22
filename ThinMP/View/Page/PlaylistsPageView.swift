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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(title: LabelConstant.playlists, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                        EditButtonView {
                            PlaylistsEditPageView()
                        }
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack(spacing: 0) {
                                ForEach(vm.playlists) { playlist in
                                    NavigationLink(destination: PlaylistDetailPageView(playlistId: playlist.playlistId)) {
                                        MediaRowView(media: playlist)
                                    }
                                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                    .contextMenu {
                                        PlaylistDeleteButtonView(playlistId: playlist.playlistId) { vm.load() }
                                        ShortcutButtonView(itemId: playlist.id, type: ShortcutType.PLAYLIST)
                                    }
                                    Divider()
                                }
                                .padding(.leading, StyleConstant.Padding.medium)
                            }
                        }
                    }
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load() }
            }
            .modifier(PageModifier())
            .task {
                await vm.load().value
            }
        }
    }
}

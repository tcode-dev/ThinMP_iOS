//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import MediaPlayer
import SwiftUI

struct PlaylistDetailPageView: View {
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var headerRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterSongId = SongId(id: 0)
    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active

    let playlistId: PlaylistId

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.primaryText, side: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            VStack {
                                MenuButtonView {
                                    VStack {
                                        Button("Edit") {
                                            isEdit = true
                                        }
                                        ShortcutButtonView(itemId: playlistId.id, type: ShortcutType.PLAYLIST)
                                    }
                                }
                                NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.primaryText).environment(\.editMode, $editMode), isActive: $isEdit) {
                                    EmptyView()
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                PlaylistDetailHeaderView(headerRect: $headerRect, side: geometry.size.width, top: geometry.safeAreaInsets.top, name: vm.primaryText, artwork: vm.artwork)
                                LazyVStack(spacing: 0) {
                                    ForEach(vm.songs.indices, id: \.self) { index in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: vm.songs[index])
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                        .contextMenu {
                                            FavoriteSongButtonView(songId: vm.songs[index].songId)
                                            Button(action: {
                                                playlistRegisterSongId = vm.songs[index].songId
                                                showingPopup.toggle()
                                            }) {
                                                Text("AddPlaylist")
                                            }
                                        }
                                        Divider()
                                    }.padding(.leading, StyleConstant.Padding.medium)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if showingPopup {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(songId: playlistRegisterSongId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                vm.load(playlistId: playlistId)
            }
        }
    }
}

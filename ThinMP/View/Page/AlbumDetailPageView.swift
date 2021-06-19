//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailPageView: View {
    @StateObject private var vm = AlbumDetailViewModel()
    @State private var textRect: CGRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterId: MPMediaEntityPersistentID = 0

    private let persistentId: MPMediaEntityPersistentID

    init(persistentId: MPMediaEntityPersistentID) {
        self.persistentId = persistentId
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.primaryText, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                VStack {
                                    ShortcutButtonView(itemId: persistentId, type: ShortcutType.ALBUM)
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                AlbumDetailHeaderView(vm: vm, textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                                LazyVStack(spacing: 0) {
                                    ForEach(vm.songs.indices, id: \.self) { index in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: vm.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: vm.songs[index].persistentId)
                                            Button(action: {
                                                playlistRegisterId = vm.songs[index].persistentId
                                                showingPopup.toggle()
                                            }) {
                                                Text("AddPlaylist")
                                            }
                                        }
                                        Divider()
                                    }.padding(.leading, 10)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if (showingPopup) {
                    PopupView(showingPopup: self.$showingPopup) {
                        PlaylistRegisterView(persistentId: self.playlistRegisterId, height: geometry.size.height, showingPopup: self.$showingPopup)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                vm.load(persistentId: persistentId)
            }
        }
    }
}

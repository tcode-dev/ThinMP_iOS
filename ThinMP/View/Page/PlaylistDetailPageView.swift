//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI
import MediaPlayer

struct PlaylistDetailPageView: View {
    private let BUTTON_TEXT: String = "Edit"
    private let ADD_TEXT: String = "プレイリストに追加"

    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var textRect: CGRect = CGRect.zero
    @State private var headerRect: CGRect = CGRect()
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterId: MPMediaEntityPersistentID = 0
    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active

    let playlistId: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.primaryText, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            VStack {
                                MenuButtonView {
                                    VStack {
                                        Button(BUTTON_TEXT) {
                                            self.isEdit = true
                                        }
                                        ShortcutButtonView(itemId: playlistId, type: ShortcutType.PLAYLIST)
                                    }
                                }
                                NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.primaryText).environment(\.editMode, $editMode), isActive: $isEdit) {
                                    EmptyView()
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                PlaylistDetailHeaderView(textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top, name: vm.primaryText, artwork: vm.artwork)
                                LazyVStack(spacing: 0) {
                                    ForEach(vm.songs.indices, id: \.self){ index in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: vm.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: vm.songs[index].persistentId)
                                            Button(action: {
                                                playlistRegisterId = vm.songs[index].persistentId
                                                showingPopup.toggle()
                                            }) {
                                                Text(ADD_TEXT)
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
                        PlaylistRegisterView(persistentId: playlistRegisterId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                vm.load(playlistId: playlistId)
            }
        }
    }
}

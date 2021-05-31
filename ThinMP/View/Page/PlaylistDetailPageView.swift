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
    @State private var persistentID: MPMediaEntityPersistentID?
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
                                        ShortcutButtonView(itemId: playlistId, type: ShortcutType.PLAYLIST)
                                        Button(BUTTON_TEXT) {
                                            self.isEdit = true
                                        }
                                    }
                                }
                                NavigationLink(destination: PlaylistDetailEditPageView(vm: vm).environment(\.editMode, $editMode), isActive: $isEdit) {
                                    EmptyView()
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                PlaylistDetailHeaderView(textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top, name: vm.primaryText, artwork: vm.artwork)
                                LazyVStack() {
                                    ForEach(vm.list.indices, id: \.self){ index in
                                        PlayRowView(list: vm.list, index: index) {
                                            MediaRowView(media: vm.list[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: vm.list[index].persistentId)
                                            Button(action: {
                                                persistentID = vm.list[index].persistentId
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
                        PlaylistRegisterView(persistentId: persistentID!, showingPopup: $showingPopup, height: geometry.size.height)
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

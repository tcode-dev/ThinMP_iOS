//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongsPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"
    private let TITLE: String = "Songs"

    @StateObject private var vm = SongsViewModel()
    @State private var headerRect: CGRect = CGRect()
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterId: MPMediaEntityPersistentID = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                            HStack {
                                BackButtonView()
                                Spacer()
                                PrimaryTextView(TITLE)
                                Spacer()
                                Spacer()
                                    .frame(width: 50)
                            }
                        }
                        ScrollView() {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
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
                                                Text(ADD_TEXT)
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                        .frame(alignment: .top)
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if (showingPopup) {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(persistentId: playlistRegisterId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                vm.load()
            }
        }
    }
}

//
//  FavoriteSongsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI
import MediaPlayer

struct FavoriteSongsPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"
    private let TITLE: String = "Favorite Songs"

    @StateObject private var vm = FavoriteSongsViewModel()
    @State private var headerRect: CGRect = CGRect()
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?

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
                                EditButtonView {
                                    FavoriteSongsEditPageView(vm: vm)
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                                LazyVStack() {
                                    ForEach(vm.songs.indices, id: \.self) { index in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: vm.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: vm.songs[index].persistentId)
                                            Button(action: {
                                                persistentID = vm.songs[index].persistentId
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
                        PlaylistRegisterView(persistentId: persistentID!, showingPopup: $showingPopup, height: geometry.size.height)
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

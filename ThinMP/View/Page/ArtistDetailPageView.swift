//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI
import MediaPlayer

struct ArtistDetailPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"
    private let ALBUMS: String = "Albums"
    private let SONGS: String = "Songs"
    private let LEADING: CGFloat = 20
    private let BOTTOM: CGFloat = 20

    @StateObject private var vm = ArtistDetailViewModel()
    @State private var textRect: CGRect = CGRect()
    @State private var isRegister: Bool = false
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterId: MPMediaEntityPersistentID?

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
                                    FavoriteArtistButtonView(persistentId: persistentId)
                                    ShortcutButtonView(itemId: persistentId, type: ShortcutType.ARTIST)
                                }
                            }
                        }
                        ScrollView{
                            ArtistDetailHeaderView(artistDetail: vm, textRect: $textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                            VStack(alignment: .leading) {
                                PrimaryTitleView(ALBUMS)
                                    .padding(.leading, LEADING)
                                ArtistAlbumListView(list: vm.albums, width: geometry.size.width)
                                    .padding(.bottom, BOTTOM)
                                PrimaryTitleView(SONGS)
                                    .padding(.leading, LEADING)
                                LazyVStack() {
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
                                    }.padding(.leading, LEADING)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if (showingPopup) {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(persistentId: playlistRegisterId!, showingPopup: $showingPopup, height: geometry.size.height)
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

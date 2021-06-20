//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI
import MediaPlayer

struct ArtistDetailPageView: View {
    private let leading: CGFloat = 20
    private let bottom: CGFloat = 20

    @StateObject private var vm = ArtistDetailViewModel()
    @State private var textRect: CGRect = CGRect()
    @State private var isRegister: Bool = false
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterId: MPMediaEntityPersistentID = 0

    private let artistId: ArtistId

    init(artistId: ArtistId) {
        self.artistId = artistId
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.primaryText, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                VStack {
                                    FavoriteArtistButtonView(artistId: artistId)
                                    ShortcutButtonView(itemId: artistId.id, type: ShortcutType.ARTIST)
                                }
                            }
                        }
                        ScrollView{
                            ArtistDetailHeaderView(vm: vm, textRect: $textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                            VStack(alignment: .leading) {
                                PrimaryTitleView("Albums")
                                    .padding(.leading, leading)
                                ArtistAlbumListView(list: vm.albums, width: geometry.size.width)
                                    .padding(.bottom, bottom)
                                PrimaryTitleView("Songs")
                                    .padding(.leading, leading)
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
                                                Text("AddPlaylist")
                                            }
                                        }
                                        Divider()
                                    }.padding(.leading, leading)
                                }
                            }
                        }
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
                vm.load(artistId: artistId)
            }
        }
    }
}

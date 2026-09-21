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
                        HeroNavBarView(primaryText: vm.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            VStack {
                                MenuButtonView {
                                    VStack {
                                        NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.primaryText)) {
                                            MenuRowView(text: LabelConstant.edit)
                                        }
                                        ShortcutButtonView(itemId: playlistId.id, type: ShortcutType.PLAYLIST)
                                    }
                                }
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, primaryText: vm.primaryText, secondaryText: LabelConstant.playlist) {
                                    HeroSquareImageView(width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, artwork: vm.artwork)
                                }
                                LazyVStack(spacing: 0) {
                                    ForEach(rows, id: \.id) { row in
                                        PlayRowView(list: vm.songs, index: row.index) {
                                            MediaRowView(media: row.song)
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                        .contextMenu {
                                            FavoriteSongButtonView(songId: row.song.songId)
                                            Button(action: {
                                                playlistRegisterSongId = row.song.songId
                                                showingPopup.toggle()
                                            }) {
                                                Text(LocalizedStringKey(LabelConstant.addPlaylist))
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading, StyleConstant.Padding.medium)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load(playlistId: playlistId) }
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

    // プレイリストは同じ曲を重複して登録できるので、songId 単独では ForEach の ID が衝突する
    // index と組み合わせて一意にする
    private var rows: [(id: String, index: Int, song: SongModel)] {
        vm.songs.enumerated().map { (id: "\($0.offset)-\($0.element.id)", index: $0.offset, song: $0.element) }
    }
}

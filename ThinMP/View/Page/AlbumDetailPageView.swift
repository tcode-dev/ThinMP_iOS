//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"

    @ObservedObject var albumDetail: AlbumDetailViewModel

    @State private var textRect: CGRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?

    init(persistentId: MPMediaEntityPersistentID) {
        self.albumDetail = AlbumDetailViewModel(persistentId: persistentId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: self.albumDetail.title, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                EmptyView()
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                AlbumDetailHeaderView(albumDetail: self.albumDetail, textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                                LazyVStack() {
                                    ForEach(self.albumDetail.songs.indices){ index in
                                        PlayRowView(list: self.albumDetail.songs, index: index) {
                                            MediaRowView(media: self.albumDetail.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: self.albumDetail.songs[index].persistentID)
                                            Button(action: {
                                                persistentID = self.albumDetail.songs[index].persistentID
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
                        PlaylistRegisterView(persistentId: self.persistentID!, showingPopup: self.$showingPopup, height: geometry.size.height)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

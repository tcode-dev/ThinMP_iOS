//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI
import MediaPlayer

struct PlaylistDetailPageView: View {
    @ObservedObject var playlistDetail: PlaylistDetailViewModel
    @State private var textRect: CGRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?
    @State private var headerRect: CGRect = CGRect()

    init(playlistId: String) {
        self.playlistDetail = PlaylistDetailViewModel(playlistId: playlistId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: self.playlistDetail.name, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                EmptyView()
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                PlaylistDetailHeaderView(textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top, name: self.playlistDetail.name, artwork: self.playlistDetail.artwork)
                                LazyVStack() {
                                    ForEach(self.playlistDetail.songs.indices, id: \.self){ index in
                                        PlayRowView(list: self.playlistDetail.songs, index: index) {
                                            MediaRowView(media: self.playlistDetail.songs[index])
                                        }
                                        Divider()
                                    }.padding(.leading, 10)
                                }
                            }
                        }
                        .navigationBarHidden(true)
                        .navigationBarTitle(Text(""))
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                .edgesIgnoringSafeArea(.all)
                if (showingPopup) {
                    PopupView(showingPopup: self.$showingPopup) {
                        PlaylistRegisterView(persistentId: self.persistentID!, showingPopup: self.$showingPopup, height: geometry.size.height)
                    }
                }
            }
        }
    }
}

//
//  PlaylistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsPageView: View {
    private let TITLE: String = "Playlists"

    @StateObject private var playlists = PlaylistViewModel()
    @State private var headerRect: CGRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                        HStack {
                            BackButtonView()
                            Spacer()
                            PrimaryTextView(TITLE)
                            Spacer()
                            EditButtonView {
                                PlaylistsEditPageView(playlists: playlists)
                            }
                        }
                    }
                    ScrollView() {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack() {
                                ForEach(self.playlists.list.indices, id: \.self) { index in
                                    NavigationLink(destination: PlaylistDetailPageView(playlistId: self.playlists.list[index].id)) {
                                        MediaRowView(media: self.playlists.list[index])
                                    }
                                    Divider()
                                }.padding(.leading, 10)
                            }
                        }
                    }
                    .frame(alignment: .top)
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                playlists.load()
            }
        }
    }
}

//
//  PlaylistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct PlaylistsPageView: View {
    @ObservedObject var playlists = PlaylistViewModel()
    @State private var headerRect: CGRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    PlaylistsNavBarView(top: geometry.safeAreaInsets.top, rect: self.$headerRect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            ForEach(self.playlists.list.indices, id: \.self) { index in
                                NavigationLink(destination: PlaylistDetailPageView()) {
                                    PrimaryTextView(self.playlists.list[index].name)
                                    Spacer()
                                }
                                Divider()
                            }.padding(.leading, 10)
                        }
                    }
                    .frame(alignment: .top)
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .onAppear() {
                    playlists.load()
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

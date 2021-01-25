//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    @ObservedObject var artists = FavoriteArtistsViewModel()
    @State private var headerRect: CGRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    FavoriteArtistsHeaderView(top: geometry.safeAreaInsets.top, rect: self.$headerRect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            ForEach(self.artists.list) { artist in
                                NavigationLink(destination: ArtistDetailPageView(artist: artist)) {
                                    ArtistRowView(artist: artist)
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
                    artists.load()
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

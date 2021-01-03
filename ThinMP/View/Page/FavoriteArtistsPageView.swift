//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    @ObservedObject var artists = FavoriteArtistsViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            ListHeaderView(primaryText: "FavoriteArtists")
            List(self.artists.list.indices) { index in
                HStack {
                    ArtistRowView(artist: self.artists.list[index])
                    NavigationLink(destination: ArtistDetailPageView(artist: self.artists.list[index])) {
                        EmptyView()
                    }
                    Spacer()
                }
            }
            .padding(.init(top: 50, leading: 0, bottom: 0, trailing: 0))
            .frame(alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}

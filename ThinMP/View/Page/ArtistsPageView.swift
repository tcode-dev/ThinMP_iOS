//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @ObservedObject var artists = ArtistsViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            ListHeaderView(primaryText: "artists")
            ScrollView{
                VStack(alignment: .leading) {
                    ForEach(artists.list) { artist in
                        NavigationLink(destination: ArtistDetailPageView(artist: artist)) {
                            ArtistRowView(artist: artist)
                        }
                        Divider()
                    }
                }
            }
            .padding(.init(top: 50, leading: 0, bottom: 0, trailing: 0))
            .frame(alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}

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
            List(self.artists.list.indices) { index in
                VStack {
                    ArtistRowView(artist: self.artists.list[index])
                    NavigationLink(destination: ArtistDetailPageView(artist: self.artists.list[index])) {
                        EmptyView()
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

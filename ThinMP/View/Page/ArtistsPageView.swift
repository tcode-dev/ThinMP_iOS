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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ListHeaderView(primaryText: "artists", top: geometry.safeAreaInsets.top)
                List(self.artists.list.indices) { index in
                    NavigationLink(destination: ArtistDetailPageView(artist: self.artists.list[index])) {
                        ArtistRowView(artist: self.artists.list[index])
                    }
                }
                .padding(.init(top: 50 + geometry.safeAreaInsets.top, leading: 0, bottom: 0, trailing: 0))
                .frame(alignment: .top)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

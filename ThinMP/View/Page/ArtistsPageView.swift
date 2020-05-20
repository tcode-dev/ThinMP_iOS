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
        ScrollView{
            VStack(alignment: .leading) {

                ForEach(artists.list) { artist in
                    NavigationLink(destination: ArtistDetailPageView(artist: artist)) {
                        ArtistRowView(artist: artist)
                    }
                    Divider()
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
        }
    }
}

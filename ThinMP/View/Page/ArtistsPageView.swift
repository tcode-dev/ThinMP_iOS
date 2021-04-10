//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @ObservedObject var artists = ArtistsViewModel()
    @State private var headerRect: CGRect = CGRect()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ArtistsNavBarView(top: geometry.safeAreaInsets.top, rect: self.$headerRect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            ForEach(self.artists.list.indices, id: \.self){ index in
                                VStack {
                                    NavigationLink(destination: ArtistDetailPageView(artist: self.artists.list[index])) {
                                        ArtistRowView(artist: self.artists.list[index])
                                    }
                                    Divider()
                                }
                            }
                            .padding(.leading, 10)
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

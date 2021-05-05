//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    private let TITLE: String = "Favorite Artists"
    
    @State private var headerRect: CGRect = CGRect()
    
    @ObservedObject var artists = FavoriteArtistsViewModel()
    
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
                                FavoriteArtistsEditPageView(artists: artists)
                            }
                        }
                    }
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack() {
                                ForEach(self.artists.list) { artist in
                                    NavigationLink(destination: ArtistDetailPageView(artist: artist)) {
                                        MediaRowView(media: artist)
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
                artists.load()
            }
        }
    }
}

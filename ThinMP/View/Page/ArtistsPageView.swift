//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    private let TITLE: String = "Artists"

    @ObservedObject var artists = ArtistsViewModel()
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
                            Spacer()
                                .frame(width: 50)
                        }
                    }
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack() {
                                ForEach(self.artists.list.indices, id: \.self) { index in
                                    NavigationLink(destination: ArtistDetailPageView(artist: self.artists.list[index])) {
                                        MediaRowView(media: self.artists.list[index])
                                    }
                                    Divider()
                                }
                                .padding(.leading, 10)
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

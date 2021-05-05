//
//  FavoriteSongsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI

struct FavoriteSongsPageView: View {
    private let TITLE: String = "Favorite Songs"

    @ObservedObject var songs = FavoriteSongsViewModel()
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
                            EditButtonView {
                                FavoriteSongsEditPageView(songs: songs)
                            }
                        }
                    }
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack() {
                                ForEach(self.songs.list.indices, id: \.self) { index in
                                    PlayRowView(list: self.songs.list, index: index) {
                                        MediaRowView(media: self.songs.list[index])
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
                songs.load()
            }
        }
    }
}

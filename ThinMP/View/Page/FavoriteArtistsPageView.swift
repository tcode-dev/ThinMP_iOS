//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    @StateObject private var vm = FavoriteArtistsViewModel()
    @State private var headerRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                        HStack {
                            BackButtonView()
                            Spacer()
                            HeaderTitleView("FavoriteArtists")
                            Spacer()
                            EditButtonView {
                                FavoriteArtistsEditPageView()
                            }
                        }
                    }
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack(spacing: 0) {
                                ForEach(vm.artists) { artist in
                                    NavigationLink(destination: ArtistDetailPageView(artistId: artist.artistId)) {
                                        PlainRowView(media: artist)
                                    }
                                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                    .contextMenu {
                                        FavoriteArtistButtonView(artistId: artist.artistId) { vm.load() }
                                        ShortcutButtonView(itemId: artist.id, type: ShortcutType.ARTIST)
                                    }
                                    Divider()
                                }.padding(.leading, StyleConstant.Padding.medium)
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
            .onAppear {
                vm.load()
            }
        }
    }
}

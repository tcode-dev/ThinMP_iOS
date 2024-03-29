//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @StateObject private var vm = ArtistsViewModel()
    @State private var headerRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                        HStack {
                            BackButtonView()
                            Spacer()
                            HeaderTitleView(LabelConstant.artists)
                            Spacer()
                            Spacer()
                                .frame(width: StyleConstant.button)
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
                                        FavoriteArtistButtonView(artistId: artist.artistId)
                                        ShortcutButtonView(itemId: artist.id, type: ShortcutType.ARTIST)
                                    }
                                    Divider()
                                }
                                .padding(.leading, StyleConstant.Padding.medium)
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

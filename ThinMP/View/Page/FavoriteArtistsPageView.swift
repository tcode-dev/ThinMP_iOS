//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    @StateObject private var vm = FavoriteArtistsViewModel()
    @State private var headerRect = CGRect.zero

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(title: LabelConstant.favoriteArtists, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                        EditButtonView {
                            FavoriteArtistsEditPageView()
                        }
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            ArtistListView(artists: vm.artists) { vm.load() }
                        }
                    }
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load() }
            }
            .modifier(PageModifier())
            .task {
                await vm.load().value
            }
        }
    }
}

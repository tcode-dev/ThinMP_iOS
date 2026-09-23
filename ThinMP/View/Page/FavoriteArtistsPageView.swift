//
//  FavoriteArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import SwiftUI

struct FavoriteArtistsPageView: View {
    @StateObject private var vm = FavoriteArtistsViewModel()
    @State private var isScrolledUnder = false

    var body: some View {
        ScrollPageLayout(onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(titleKey: LabelConstant.favoriteArtists, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                EditButtonView {
                    FavoriteArtistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            ArtistListView(artists: vm.artists) { vm.load() }
        }
        .onAppear {
            vm.load()
        }
    }
}

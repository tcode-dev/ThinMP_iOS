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
        ScrollPageLayout(onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(title: LabelConstant.favoriteArtists, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                EditButtonView {
                    FavoriteArtistsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
            ArtistListView(artists: vm.artists) { vm.load() }
        }
        .task {
            await vm.load().value
        }
    }
}

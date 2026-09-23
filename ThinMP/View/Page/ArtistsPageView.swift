//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @StateObject private var vm = ArtistsViewModel()
    @State private var isScrolledUnder = false

    var body: some View {
        ScrollPageLayout { geometry in
            ListNavBarView(titleKey: LabelConstant.artists, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder)
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            ArtistListView(artists: vm.artists)
        }
        .onFirstAppear {
            vm.load()
        }
    }
}

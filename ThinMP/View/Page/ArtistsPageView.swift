//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @StateObject private var vm = ArtistsViewModel()
    @State private var headerRect = CGRect.zero

    var body: some View {
        ScrollPageLayout { geometry in
            ListNavBarView(title: LabelConstant.artists, top: geometry.safeAreaInsets.top, headerRect: $headerRect)
        } content: { geometry in
            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
            ArtistListView(artists: vm.artists)
        }
        .task {
            await vm.load().value
        }
    }
}

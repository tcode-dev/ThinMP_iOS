//
//  AlbumsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsPageView: View {
    @StateObject private var vm = AlbumsViewModel()
    @State private var isScrolledUnder = false

    var body: some View {
        ScrollPageLayout { geometry in
            ListNavBarView(titleKey: LabelConstant.albums, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder)
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            AlbumListView(albums: vm.albums, width: geometry.size.width)
        }
        .task {
            await vm.load().value
        }
    }
}

//
//  AlbumsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsPageView: View {
    @StateObject private var vm = AlbumsViewModel()
    @State private var headerRect = CGRect.zero

    var body: some View {
        ScrollPageLayout { geometry in
            ListNavBarView(title: LabelConstant.albums, top: geometry.safeAreaInsets.top, headerRect: $headerRect)
        } content: { geometry in
            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
            AlbumListView(albums: vm.albums, width: geometry.size.width)
        }
        .task {
            await vm.load().value
        }
    }
}

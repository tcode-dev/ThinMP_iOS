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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(title: LabelConstant.albums, top: geometry.safeAreaInsets.top, headerRect: $headerRect)
                    ScrollView {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            AlbumListView(albums: vm.albums, width: geometry.size.width)
                        }
                    }
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .modifier(PageModifier())
            .task {
                await vm.load().value
            }
        }
    }
}

//
//  AlbumsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsPageView: View {
    @StateObject private var vm = AlbumsViewModel()
    @State private var headerRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                        HStack {
                            BackButtonView()
                            Spacer()
                            HeaderTitleView(LabelConstant.albums)
                            Spacer()
                            Spacer()
                                .frame(width: StyleConstant.button)
                        }
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            AlbumListView(albums: vm.albums, width: geometry.size.width)
                        }
                    }
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
            .task {
                await vm.load().value
            }
        }
    }
}

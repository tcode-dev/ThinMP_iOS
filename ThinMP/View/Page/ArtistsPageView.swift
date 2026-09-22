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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(title: LabelConstant.artists, top: geometry.safeAreaInsets.top, headerRect: $headerRect)
                    ScrollView {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                            ArtistListView(artists: vm.artists)
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

//
//  ArtistsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsPageView: View {
    @StateObject private var vm = ArtistsViewModel()
    @State private var headerRect: CGRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                        HStack {
                            BackButtonView()
                            Spacer()
                            SecondaryTitleView("Artists")
                            Spacer()
                            Spacer()
                                .frame(width: 50)
                        }
                    }
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVStack(spacing: 0) {
                                ForEach(vm.artists.indices, id: \.self) { index in
                                    NavigationLink(destination: ArtistDetailPageView(artistId: vm.artists[index].artistId)) {
                                        MediaRowView(media: vm.artists[index])
                                    }
                                    Divider()
                                }
                                .padding(.leading, StyleConstant.padding.medium)
                            }
                        }
                    }
                    .frame(alignment: .top)
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                vm.load()
            }
        }
    }
}

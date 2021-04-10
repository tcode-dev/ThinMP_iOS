//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsPageView: View {
    @ObservedObject var songs = SongsViewModel()
    @State private var headerRect: CGRect = CGRect()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    SongsNavBarView(top: geometry.safeAreaInsets.top, rect: self.$headerRect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                            LazyVGrid(columns: [GridItem()]) {
                                ForEach(self.songs.list.indices, id: \.self){ index in
                                    VStack {
                                        PlayRowView(list: self.songs.list, index: index) {
                                            SongRowView(song: self.songs.list[index])
                                        }
                                        Divider()
                                    }
                                }
                                .padding(.leading, 10)
                            }
                        }
                    }
                    .frame(alignment: .top)
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .onAppear() {
                    songs.load()
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

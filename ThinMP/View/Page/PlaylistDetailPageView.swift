//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI
import MediaPlayer

struct PlaylistDetailPageView: View {
    @StateObject var vm: PlaylistDetailViewModel
    @State private var textRect: CGRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?
    @State private var headerRect: CGRect = CGRect()
    let playlistId: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.name, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            EditButtonView {
                                PlaylistDetailEditPageView(vm: vm)
                            }
                        }
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading) {
                                PlaylistDetailHeaderView(textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top, name: vm.name, artwork: vm.artwork)
                                LazyVStack() {
                                    ForEach(vm.list.indices, id: \.self){ index in
                                        PlayRowView(list: vm.list, index: index) {
                                            MediaRowView(media: vm.list[index])
                                        }
                                        Divider()
                                    }.padding(.leading, 10)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if (showingPopup) {
                    PopupView(showingPopup: self.$showingPopup) {
                        PlaylistRegisterView(persistentId: self.persistentID!, showingPopup: self.$showingPopup, height: geometry.size.height)
                    }
                }
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

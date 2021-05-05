//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongsPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"
    private let TITLE: String = "Songs"

    @ObservedObject var vm = SongsViewModel()
    @State private var headerRect: CGRect = CGRect()
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                            HStack {
                                BackButtonView()
                                Spacer()
                                PrimaryTextView(TITLE)
                                Spacer()
                                Spacer()
                                    .frame(width: 50)
                            }
                        }
                        ScrollView() {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                                LazyVStack() {
                                    ForEach(vm.list.indices, id: \.self) { index in
                                        PlayRowView(list: vm.list, index: index) {
                                            MediaRowView(media: vm.list[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: vm.list[index].persistentID)
                                            Button(action: {
                                                persistentID = vm.list[index].persistentID
                                                showingPopup.toggle()
                                            }) {
                                                Text(ADD_TEXT)
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                        .frame(alignment: .top)
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

//
//  MainPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainPageView: View {
    private let RECENTLY_ADDED: String = "Recently Added"
    private let SHORTCUTS: String = "Shortcuts"

    private var HEADER_HEIGHT: CGFloat = 90
    private var ROW_HEIGHT: CGFloat = 44

    @StateObject private var vm = MainViewModel()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Text(LabelConstant.library).fontWeight(.bold).font(.largeTitle)
                                Spacer()
                                EditButtonView {
                                    MainEditPageView()
                                }
                            }
                            Divider()
                        }
                        .frame(height: geometry.safeAreaInsets.top + HEADER_HEIGHT)
                        .padding(.leading, 20)
                        VStack {
                            ForEach(vm.menus.indices, id: \.self) { index in
                                if (vm.menus[index].visibility) {
                                    MainMenuButtonView(menu: vm.menus[index])
                                    Divider()
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        VStack(alignment: .leading) {
                            PrimaryTitleView(SHORTCUTS)
                                .padding(.leading, 20)
                            ShortcutListView(list: vm.shortcuts, width: geometry.size.width)
                                .padding(.bottom, 10)
                        }
                        VStack(alignment: .leading) {
                            PrimaryTitleView(RECENTLY_ADDED)
                                .padding(.leading, 20)
                            AlbumListView(list: vm.albums, width: geometry.size.width)
                                .padding(.bottom, 10)
                        }
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
}

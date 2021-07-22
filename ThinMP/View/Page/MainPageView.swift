//
//  MainPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainPageView: View {
    @StateObject private var vm = MainViewModel()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                MainTitleView("Library")
                                Spacer()
                                EditButtonView {
                                    MainEditPageView()
                                }
                            }
                        }
                        .frame(height: geometry.safeAreaInsets.top + StyleConstant.Height.header)
                        .padding(.leading, StyleConstant.Padding.large)
                        VStack(spacing: 0) {
                            Divider()
                            ForEach(vm.menus.indices, id: \.self) { index in
                                if vm.menus[index].visibility {
                                    MainMenuButtonView(menu: vm.menus[index])
                                    Divider()
                                }
                            }
                        }
                        .padding(.leading, StyleConstant.Padding.medium)
                        .padding(.bottom, StyleConstant.Padding.large)
                        if vm.shortcutMenu.visibility {
                            VStack(alignment: .leading) {
                                SectionTitleView(vm.shortcutMenu.primaryText)
                                    .padding(.leading, StyleConstant.Padding.large)
                                ShortcutListView(list: vm.shortcuts, width: geometry.size.width, callback: { vm.load() })
                                    .padding(.bottom, StyleConstant.Padding.small)
                            }
                        }
                        if vm.recentlyMenu.visibility {
                            VStack(alignment: .leading) {
                                SectionTitleView(vm.recentlyMenu.primaryText)
                                    .padding(.leading, StyleConstant.Padding.large)
                                AlbumListView(list: vm.albums, width: geometry.size.width, callback: { vm.load() })
                                    .padding(.bottom, StyleConstant.Padding.small)
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    vm.load()
                }
            }
        }
    }
}

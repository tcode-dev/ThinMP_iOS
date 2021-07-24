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
                                MainTitleView(LabelConstant.library)
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
                            ForEach(vm.menus) { menu in
                                if menu.visibility {
                                    MainMenuButtonView(menu: menu)
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
                                ShortcutListView(shortcuts: vm.shortcuts, width: geometry.size.width) { vm.load() }
                                    .padding(.bottom, StyleConstant.Padding.small)
                            }
                        }
                        if vm.recentlyMenu.visibility {
                            VStack(alignment: .leading) {
                                SectionTitleView(vm.recentlyMenu.primaryText)
                                    .padding(.leading, StyleConstant.Padding.large)
                                AlbumListView(albums: vm.albums, width: geometry.size.width) { vm.load() }
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

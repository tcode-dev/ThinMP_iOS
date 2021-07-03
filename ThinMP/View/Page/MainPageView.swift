//
//  MainPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainPageView: View {
    private var HEADER_HEIGHT: CGFloat = 70

    @StateObject private var vm = MainViewModel()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Text("Library")
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                Spacer()
                                EditButtonView {
                                    MainEditPageView()
                                }
                            }
                        }
                        .frame(height: geometry.safeAreaInsets.top + HEADER_HEIGHT)
                        .padding(.leading, StyleConstant.padding.large)
                        VStack(spacing: 0) {
                            Divider()
                            ForEach(vm.menus.indices, id: \.self) { index in
                                if (vm.menus[index].visibility) {
                                    MainMenuButtonView(menu: vm.menus[index])
                                    Divider()
                                }
                            }
                        }
                        .padding(.leading, StyleConstant.padding.large)
                        .padding(.bottom, StyleConstant.padding.large)
                        if (vm.shortcutMenu.visibility) {
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(vm.shortcutMenu.primaryText!))
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .padding(.leading, StyleConstant.padding.large)
                                ShortcutListView(list: vm.shortcuts, width: geometry.size.width)
                                    .padding(.bottom, StyleConstant.padding.medium)
                            }
                        }
                        if (vm.recentlyMenu.visibility) {
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(vm.recentlyMenu.primaryText!))
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .padding(.leading, StyleConstant.padding.large)
                                AlbumListView(list: vm.albums, width: geometry.size.width)
                                    .padding(.bottom, StyleConstant.padding.medium)
                            }
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

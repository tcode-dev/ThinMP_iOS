//
//  MainEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/06/08.
//

import SwiftUI

struct MainEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation
    @StateObject private var vm = MainEditViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            back()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                        Button(action: {
                            update()
                            back()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                    }
                    .padding(.horizontal, StyleConstant.Padding.large)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach(vm.menus) { menu in
                            MenuEditRowView(menu: menu)
                        }
                        .onMove(perform: moveMenu)
                        .listRowInsets(.init())
                        MenuEditRowView(menu: vm.shortcutMenu)
                        ForEach(vm.shortcuts) { shortcut in
                            ShortcutRowView(shortcut: shortcut)
                        }
                        .onMove(perform: moveShortcut)
                        .onDelete(perform: deleteShortcut)
                        .listRowInsets(.init())
                        MenuEditRowView(menu: vm.recentlyMenu)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                vm.load()
            }
        }
    }

    private func moveMenu(source: IndexSet, destination: Int) {
        vm.menus.move(fromOffsets: source, toOffset: destination)
    }

    private func moveShortcut(source: IndexSet, destination: Int) {
        vm.shortcuts.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteShortcut(offsets: IndexSet) {
        vm.shortcuts.remove(atOffsets: offsets)
    }

    private func update() {
        let mainMenuConfig = MainMenuConfig()
        let menus = vm.menus.map { $0.primaryText }

        mainMenuConfig.setSort(value: menus)

        vm.menus.forEach {
            mainMenuConfig.setVisibility(value: $0.visibility, key: $0.primaryText)
        }

        let mainSectionConfig = MainSectionConfig()

        mainSectionConfig.setShortcutVisibility(value: vm.shortcutMenu.visibility)
        mainSectionConfig.setRecentlyVisibility(value: vm.recentlyMenu.visibility)

        let shortcutRegister = ShortcutRegister()
        let shortcutIds = vm.shortcuts.map { $0.shortcutId }

        shortcutRegister.update(shortcutIds: shortcutIds)
    }

    private func back() {
        presentation.wrappedValue.dismiss()
    }
}

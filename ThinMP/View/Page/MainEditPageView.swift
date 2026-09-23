//
//  MainEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/06/08.
//

import SwiftUI

struct MainEditPageView: View {
    @StateObject private var vm = MainEditViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ForEach($vm.settings.menus) { $setting in
                    MenuEditRowView(text: setting.menu.label, isVisible: $setting.isVisible)
                }
                .onMove(perform: moveMenu)
                .listRowInsets(.init())
                MenuEditRowView(text: LabelConstant.shortcut, isVisible: $vm.settings.isShortcutVisible).listRowInsets(.init())
                MenuEditRowView(text: LabelConstant.recentlyAdded, isVisible: $vm.settings.isRecentlyVisible).listRowInsets(.init())
                SectionTitleView(key: LabelConstant.shortcut).padding(StyleConstant.Padding.tiny)
                ReorderableListView(items: $vm.shortcuts) { shortcut in
                    ShortcutRowView(shortcut: shortcut)
                }
            }
        }
        .task {
            await vm.load().value
        }
    }

    private func moveMenu(source: IndexSet, destination: Int) {
        vm.settings.menus.move(fromOffsets: source, toOffset: destination)
    }
}

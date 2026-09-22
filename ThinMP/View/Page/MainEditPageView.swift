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
        EditPageLayout(onDone: update) {
            List {
                ForEach($vm.settings.menus) { $setting in
                    MenuEditRowView(text: setting.menu.label, visibility: $setting.visibility)
                }
                .onMove(perform: moveMenu)
                .listRowInsets(.init())
                MenuEditRowView(text: LabelConstant.shortcut, visibility: $vm.settings.isShortcutVisible).listRowInsets(.init())
                MenuEditRowView(text: LabelConstant.recentlyAdded, visibility: $vm.settings.isRecentlyVisible).listRowInsets(.init())
                SectionTitleView(LabelConstant.shortcut).padding(StyleConstant.Padding.tiny)
                ForEach(vm.shortcuts) { shortcut in
                    ShortcutRowView(shortcut: shortcut)
                }
                .onMove(perform: moveShortcut)
                .onDelete(perform: deleteShortcut)
                .listRowInsets(.init())
            }
        }
        .task {
            await vm.load().value
        }
    }

    private func moveMenu(source: IndexSet, destination: Int) {
        vm.settings.menus.move(fromOffsets: source, toOffset: destination)
    }

    private func moveShortcut(source: IndexSet, destination: Int) {
        vm.shortcuts.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteShortcut(offsets: IndexSet) {
        vm.shortcuts.remove(atOffsets: offsets)
    }

    private func update() {
        vm.save()
        ShortcutRegister().update(shortcutIds: vm.shortcuts.map { $0.shortcutId })
    }
}

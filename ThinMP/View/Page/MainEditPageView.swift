//
//  MainEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/06/08.
//

import SwiftUI

struct MainEditPageView: View {
    @State private var vm = MainEditViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.draft != nil, onDone: vm.save) {
            List {
                if let draft = Binding($vm.draft) {
                    ForEach(draft.settings.menus) { $setting in
                        MenuEditRowView(label: setting.menu.label, isVisible: $setting.isVisible)
                    }
                    .onMove(perform: moveMenu)
                    .listRowInsets(.init())
                    MenuEditRowView(label: .shortcut, isVisible: draft.settings.isShortcutVisible).listRowInsets(.init())
                    MenuEditRowView(label: .recentlyAdded, isVisible: draft.settings.isRecentlyVisible).listRowInsets(.init())
                    SectionTitleView(label: .shortcut).padding(StyleConstant.Padding.tiny)
                    ReorderableListView(items: draft.shortcuts) { shortcut in
                        ShortcutRowView(shortcut: shortcut)
                    }
                }
            }
        }
        .task {
            await vm.load()
        }
    }

    private func moveMenu(source: IndexSet, destination: Int) {
        vm.draft?.settings.menus.move(fromOffsets: source, toOffset: destination)
    }
}

//
//  MainViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct MainViewModelTests {
    private let shortcut = ShortcutModel(shortcutId: ShortcutId(id: "s1"), target: .artist(ArtistId(id: 10)), primaryText: "Artist", artwork: nil)
    private let album = AlbumModel(albumId: AlbumId(id: 1), primaryText: "Album", secondaryText: nil, artwork: nil)

    private func makeSettings(isShortcutVisible: Bool, isRecentlyVisible: Bool) -> MainSettings {
        return MainSettings(menus: MainMenu.allCases.map { MainMenuSetting(menu: $0, isVisible: true) }, isShortcutVisible: isShortcutVisible, isRecentlyVisible: isRecentlyVisible)
    }

    @Test
    func loadPublishesSettingsShortcutsAndAlbums() async {
        let service = MainServiceMock(settings: makeSettings(isShortcutVisible: true, isRecentlyVisible: true), shortcuts: [shortcut], albums: [album])
        let vm = MainViewModel(mainService: service)

        await vm.load().value

        #expect(vm.settings == service.settings)
        #expect(vm.shortcuts.map { $0.shortcutId } == [ShortcutId(id: "s1")])
        #expect(vm.albums.map { $0.albumId.id } == [1])
    }

    /// 非表示にしているセクションは読まない(ライブラリを走査しないため)
    @Test
    func loadSkipsHiddenSections() async {
        let service = MainServiceMock(settings: makeSettings(isShortcutVisible: false, isRecentlyVisible: false), shortcuts: [shortcut], albums: [album])
        let vm = MainViewModel(mainService: service)

        await vm.load().value

        #expect(vm.shortcuts.isEmpty)
        #expect(vm.albums.isEmpty)
        #expect(service.findShortcutsCalls == 0)
        #expect(service.findRecentlyAlbumsCalls == 0)
    }
}

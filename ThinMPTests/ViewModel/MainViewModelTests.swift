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
    private let shortcut = ShortcutModel(shortcutId: ShortcutId(id: "s1"), itemId: ItemId(id: "10"), type: .artist, primaryText: "Artist")
    private let album = AlbumModel(albumId: AlbumId(id: 1), primaryText: "Album")

    private func makeSettings(isShortcutVisible: Bool, isRecentlyVisible: Bool) -> MainSettings {
        return MainSettings(menus: MainMenu.allCases.map { MainMenuSetting(menu: $0, visibility: true) }, isShortcutVisible: isShortcutVisible, isRecentlyVisible: isRecentlyVisible)
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

    /// 非表示にしているセクションは読まない(ライブラリを舐めないため)
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

@MainActor
struct MainEditViewModelTests {
    private let shortcuts = [
        ShortcutModel(shortcutId: ShortcutId(id: "s1"), itemId: ItemId(id: "10"), type: .artist, primaryText: "A"),
        ShortcutModel(shortcutId: ShortcutId(id: "s2"), itemId: ItemId(id: "20"), type: .album, primaryText: "B"),
    ]

    private func makeSettings() -> MainSettings {
        return MainSettings(menus: MainMenu.allCases.map { MainMenuSetting(menu: $0, visibility: true) }, isShortcutVisible: true, isRecentlyVisible: true)
    }

    @Test
    func loadPublishesSettingsAndAllShortcuts() async {
        var settings = makeSettings()

        settings.isShortcutVisible = false

        let service = MainServiceMock(settings: settings, shortcuts: shortcuts)
        let vm = MainEditViewModel(mainService: service)

        await vm.load().value

        // 編集ページはショートカット非表示でも並び替えのために読む
        #expect(vm.settings == settings)
        #expect(vm.shortcuts.map { $0.shortcutId.id } == ["s1", "s2"])
    }

    @Test
    func saveWritesEditedSettingsAndShortcutOrder() async {
        let service = MainServiceMock(settings: makeSettings(), shortcuts: shortcuts)
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: shortcuts.map { ShortcutEntity(shortcutId: $0.shortcutId, itemId: $0.itemId, type: $0.type) })
        let vm = MainEditViewModel(mainService: service, shortcutRepository: shortcutRepository)

        await vm.load().value
        vm.settings.isRecentlyVisible = false
        vm.settings.menus.move(fromOffsets: [0], toOffset: 2)
        vm.shortcuts.remove(at: 0)
        vm.save()

        #expect(service.savedSettings.count == 1)
        #expect(service.savedSettings[0].isRecentlyVisible == false)
        #expect(service.savedSettings[0].menus.map { $0.menu } == [.albums, .artists, .songs, .favoriteArtists, .favoriteSongs, .playlists])
        #expect(shortcutRepository.updateCalls == [[ShortcutId(id: "s2")]])
        #expect(shortcutRepository.findAll().map { $0.shortcutId } == [ShortcutId(id: "s2")])
    }
}

//
//  MainEditViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct MainEditViewModelTests {
    private let shortcuts = [
        ShortcutModel(shortcutId: ShortcutId(id: "s1"), target: .artist(ArtistId(id: 10)), primaryText: "A", artwork: nil),
        ShortcutModel(shortcutId: ShortcutId(id: "s2"), target: .album(AlbumId(id: 20)), primaryText: "B", artwork: nil),
    ]

    private func makeSettings() -> MainSettings {
        return MainSettings(menus: MainMenu.allCases.map { MainMenuSetting(menu: $0, isVisible: true) }, isShortcutVisible: true, isRecentlyVisible: true)
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
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: shortcuts.map { ShortcutEntity(shortcutId: $0.shortcutId, target: $0.target) })
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

    /// 読み込みが終わる前に完了を押しても、MainSettings.empty と空のショートカットで上書きしない
    @Test
    func saveBeforeLoadDoesNotTouchSettingsOrShortcuts() {
        let service = MainServiceMock(settings: makeSettings(), shortcuts: shortcuts)
        let shortcutRepository = ShortcutRepositoryMock(shortcuts: shortcuts.map { ShortcutEntity(shortcutId: $0.shortcutId, target: $0.target) })
        let vm = MainEditViewModel(mainService: service, shortcutRepository: shortcutRepository)

        #expect(!vm.isLoaded)
        vm.save()

        #expect(service.savedSettings.isEmpty)
        #expect(shortcutRepository.updateCalls.isEmpty)
        #expect(shortcutRepository.findAll().map { $0.shortcutId.id } == ["s1", "s2"])
    }
}

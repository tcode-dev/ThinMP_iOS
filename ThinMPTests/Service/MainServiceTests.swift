//
//  MainServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Foundation
import Testing
@testable import ThinMP

@MainActor
struct MainServiceTests {
    private func makeService(
        userDefaults: UserDefaults,
        albumRepository: AlbumRepositoryMock = AlbumRepositoryMock(),
        shortcutService: ShortcutServiceMock = ShortcutServiceMock()
    ) -> MainService {
        return MainService(
            albumRepository: albumRepository,
            shortcutService: shortcutService,
            mainMenuConfig: MainMenuConfig(userDefaults: userDefaults),
            mainSectionConfig: MainSectionConfig(userDefaults: userDefaults)
        )
    }

    @Test
    func settingsDefaultToEverythingVisible() {
        let service = makeService(userDefaults: UserDefaults.empty())

        let settings = service.getSettings()

        #expect(settings.menus == MainMenu.allCases.map { MainMenuSetting(menu: $0, visibility: true) })
        #expect(settings.isShortcutVisible)
        #expect(settings.isRecentlyVisible)
    }

    @Test
    func saveRoundTripsSettingsAcrossInstances() {
        let userDefaults = UserDefaults.empty()
        let settings = MainSettings(
            menus: [MainMenuSetting(menu: .songs, visibility: false), MainMenuSetting(menu: .artists, visibility: true)]
                + MainMenu.allCases.filter { $0 != .songs && $0 != .artists }.map { MainMenuSetting(menu: $0, visibility: true) },
            isShortcutVisible: false,
            isRecentlyVisible: true
        )

        makeService(userDefaults: userDefaults).save(settings: settings)

        #expect(makeService(userDefaults: userDefaults).getSettings() == settings)
    }

    @Test
    func findRecentlyAlbumsAsksTheRepositoryForTwenty() async {
        let albums = (1 ... 25).map { AlbumModel(albumId: AlbumId(id: UInt64($0)), primaryText: "Album \($0)") }
        let albumRepository = AlbumRepositoryMock(recently: albums)
        let service = makeService(userDefaults: UserDefaults.empty(), albumRepository: albumRepository)

        let found = await service.findRecentlyAlbums()

        #expect(found.count == 20)
        #expect(found.first?.albumId.id == 1)
        #expect(albumRepository.findRecentlyCalls == [20])
    }

    @Test
    func findShortcutsDelegatesToShortcutService() async {
        let shortcut = ShortcutModel(shortcutId: ShortcutId(id: "s1"), target: .artist(ArtistId(id: 10)), primaryText: "Artist")
        let shortcutService = ShortcutServiceMock(shortcuts: [shortcut])
        let service = makeService(userDefaults: UserDefaults.empty(), shortcutService: shortcutService)

        let found = await service.findShortcuts()

        #expect(found.map { $0.shortcutId } == [ShortcutId(id: "s1")])
        #expect(shortcutService.findAllCalls == 1)
    }
}

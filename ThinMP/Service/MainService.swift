//
//  MainService.swift
//  ThinMP
//
//  Created by tk on 2021/06/02.
//

struct MainService: MainServiceProtocol {
    private let albumCount = 20
    private let albumRepository: AlbumRepositoryProtocol
    private let shortcutService: ShortcutServiceProtocol
    private let mainMenuConfig: MainMenuConfig
    private let mainSectionConfig: MainSectionConfig

    init(
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        shortcutService: ShortcutServiceProtocol = ShortcutService(),
        mainMenuConfig: MainMenuConfig = MainMenuConfig(),
        mainSectionConfig: MainSectionConfig = MainSectionConfig()
    ) {
        self.albumRepository = albumRepository
        self.shortcutService = shortcutService
        self.mainMenuConfig = mainMenuConfig
        self.mainSectionConfig = mainSectionConfig
    }

    func findRecentlyAlbums() async -> [AlbumModel] {
        return await Task.detached(priority: .userInitiated) { [albumRepository, albumCount] in
            albumRepository.findRecently(count: albumCount)
        }.value
    }

    func findShortcuts() async -> [ShortcutModel] {
        return await shortcutService.findAll()
    }

    func loadSettings() -> MainSettings {
        return MainSettings(
            menus: mainMenuConfig.load(),
            isShortcutVisible: mainSectionConfig.isShortcutVisible,
            isRecentlyVisible: mainSectionConfig.isRecentlyVisible
        )
    }

    func save(settings: MainSettings) {
        mainMenuConfig.save(settings.menus)
        mainSectionConfig.isShortcutVisible = settings.isShortcutVisible
        mainSectionConfig.isRecentlyVisible = settings.isRecentlyVisible
    }
}

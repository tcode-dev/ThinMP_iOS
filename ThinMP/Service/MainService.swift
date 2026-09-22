//
//  MainService.swift
//  ThinMP
//
//  Created by tk on 2021/06/02.
//

struct MainService: MainServiceProtocol {
    private let ALBUM_COUNT = 20
    private let albumRepository: AlbumRepositoryProtocol
    private let shortcutService: ShortcutServiceProtocol
    private let shortcutRegister: ShortcutRegisterProtocol
    private let mainMenuConfig: MainMenuConfig
    private let mainSectionConfig: MainSectionConfig

    init(
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        shortcutService: ShortcutServiceProtocol = ShortcutService(),
        shortcutRegister: ShortcutRegisterProtocol = ShortcutRegister(),
        mainMenuConfig: MainMenuConfig = MainMenuConfig(),
        mainSectionConfig: MainSectionConfig = MainSectionConfig()
    ) {
        self.albumRepository = albumRepository
        self.shortcutService = shortcutService
        self.shortcutRegister = shortcutRegister
        self.mainMenuConfig = mainMenuConfig
        self.mainSectionConfig = mainSectionConfig
    }

    func findRecentlyAlbums() async -> [AlbumModel] {
        return await Task.detached(priority: .userInitiated) { [albumRepository, ALBUM_COUNT] in
            albumRepository.findRecently(count: ALBUM_COUNT)
        }.value
    }

    func findShortcuts() async -> [ShortcutModel] {
        return await shortcutService.findAll()
    }

    func getSettings() -> MainSettings {
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

    func update(shortcutIds: [ShortcutId]) {
        shortcutRegister.update(shortcutIds: shortcutIds)
    }
}

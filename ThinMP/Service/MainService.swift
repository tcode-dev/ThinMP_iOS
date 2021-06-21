//
//  MainService.swift
//  ThinMP
//
//  Created by tk on 2021/06/02.
//

import MediaPlayer

struct MainService {
    private let COUNT = 20

    func findRecentlyAlbums() -> [AlbumModel] {
        let repository = AlbumRepository()

        return repository.findRecently(count: COUNT)
    }

    func findShortcuts() -> [ShortcutModel] {
        let shortcutRepository = ShortcutRepository()
        let shortcutModels = shortcutRepository.findAll()
        let grouping = Dictionary(grouping: shortcutModels) { shortcutModel -> Int in
            switch shortcutModel.type {
            case ShortcutType.ARTIST.rawValue: return ShortcutType.ARTIST.rawValue
            case ShortcutType.ALBUM.rawValue: return ShortcutType.ALBUM.rawValue
            case ShortcutType.PLAYLIST.rawValue: return ShortcutType.PLAYLIST.rawValue
            default: return 0
            }
        }
        .reduce([Int: [String]]()) { dic, tuple in
            var dic = dic
            dic[tuple.key] = tuple.value.map { $0.itemId }
            return dic
        }

        var shortcutDictionary: [Int: [DetailProtocol]] = [ShortcutType.ARTIST.rawValue: [], ShortcutType.ALBUM.rawValue: [], ShortcutType.PLAYLIST.rawValue:[]]

        if let artistIds = grouping[ShortcutType.ARTIST.rawValue] {
            let artistDetailService = ArtistDetailService()
            let artistIds = artistIds.map { ArtistId(id: UInt64($0)!)}

            shortcutDictionary[ShortcutType.ARTIST.rawValue] = artistDetailService.findByIds(artistIds: artistIds)
        }

        if let albumIds = grouping[ShortcutType.ALBUM.rawValue] {
            let albumDetailService = AlbumDetailService()
            let albumIds = albumIds.map {AlbumId(id: UInt64($0)!)}

            shortcutDictionary[ShortcutType.ALBUM.rawValue] = albumDetailService.findByIds(albumIds: albumIds)
        }

        if let playlistIds = grouping[ShortcutType.PLAYLIST.rawValue] {
            let playlistDetailService = PlaylistDetailService()

            shortcutDictionary[ShortcutType.PLAYLIST.rawValue] = playlistDetailService.findByIds(playlistIds: playlistIds.map{PlaylistId(id: $0)})
        }
        
        return shortcutModels.map { shortcut -> ShortcutModel in
            let shortcut = shortcut
            let dictionary = shortcutDictionary[shortcut.type]
            let model = dictionary!.first { $0.shortcutId == shortcut.itemId }!

            return ShortcutModel(id: shortcut.id, itemId: shortcut.itemId, type: shortcut.type, primaryText: model.primaryText, artwork: model.artwork)
        }
    }

    func getMainMenus() -> [MenuModel] {
        let config = MainMenuConfig()

        return config.getList()
    }

    func getShortcutMenu() -> MenuModel {
        let config = MainSectionConfig()

        return config.getShortcut()
    }

    func getRecentlyMenu() -> MenuModel {
        let config = MainSectionConfig()

        return config.getRecently()
    }
}

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
            let persistentIds = artistIds.map { UInt64($0)! as MPMediaEntityPersistentID}

            shortcutDictionary[ShortcutType.ARTIST.rawValue] = artistDetailService.findByIds(persistentIds: persistentIds)
        }

        if let albumIds = grouping[ShortcutType.ALBUM.rawValue] {
            let albumDetailService = AlbumDetailService()
            let persistentIds = albumIds.map { UInt64($0)! as MPMediaEntityPersistentID}

            shortcutDictionary[ShortcutType.ALBUM.rawValue] = albumDetailService.findByIds(persistentIds: persistentIds)
        }

        if let playlistIds = grouping[ShortcutType.PLAYLIST.rawValue] {
            let playlistDetailService = PlaylistDetailService()

            shortcutDictionary[ShortcutType.PLAYLIST.rawValue] = playlistDetailService.findByIds(playlistIds: playlistIds)
        }
        
        return shortcutModels.map { shortcut -> ShortcutModel in
            let shortcut = shortcut
            let dictionary = shortcutDictionary[shortcut.type]
            let model = dictionary!.first { $0.shortcutId == shortcut.itemId }!

            shortcut.primaryText = model.primaryText
            shortcut.artwork = model.artwork

            return shortcut
        }
    }
}

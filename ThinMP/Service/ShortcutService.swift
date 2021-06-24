//
//  ShortcutService.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutService {
    func findAll() -> [ShortcutModel] {
        let shortcutRepository = ShortcutRepository()
        let shortcutRealmModels = shortcutRepository.findAll()
        let grouping = Dictionary(grouping: shortcutRealmModels) { shortcutModel -> Int in
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

        let shortcutModels = shortcutRealmModels.map { shortcutRealmModel -> ShortcutModel in
            let shortcut = shortcutRealmModel
            let dictionary = shortcutDictionary[shortcut.type]
            let itemModel = dictionary!.first { $0.shortcutId == shortcut.itemId }!

            return ShortcutModel(shortcutId: ShortcutId(id: shortcut.id), itemId: shortcut.itemId, type: shortcut.type, primaryText: itemModel.primaryText, artwork: itemModel.artwork)
        }

        let shortcutIds = shortcutRealmModels.map{$0.id}

        if (!validation(shortcutIds: shortcutIds, shortcutModels: shortcutModels)) {
            return findAll()
        }

        return shortcutModels
    }

    private func validation(shortcutIds: [String], shortcutModels: [ShortcutModel]) -> Bool {
        if (shortcutIds.count == shortcutModels.count) {
            return true
        }

        update(shortcutModels: shortcutModels)

        return false
    }

    private func update(shortcutModels: [ShortcutModel]) {
        let register = ShortcutRegister()
        let shortcutIds = shortcutModels.map{$0.shortcutId}

        register.update(shortcutIds: shortcutIds)
    }
}

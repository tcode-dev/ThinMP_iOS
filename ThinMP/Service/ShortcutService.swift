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
        .reduce(into: [Int: [String]]()) { $0[$1.key] = $1.value.map { $0.itemId }}

        var shortcutDictionary: [Int: [DetailProtocol]] = [ShortcutType.ARTIST.rawValue: [], ShortcutType.ALBUM.rawValue: [], ShortcutType.PLAYLIST.rawValue: []]

        if let artistIds = grouping[ShortcutType.ARTIST.rawValue] {
            let artistDetailService = ArtistDetailService()

            shortcutDictionary[ShortcutType.ARTIST.rawValue] = artistDetailService.findByIds(artistIds: artistIds.map { ArtistId(id: UInt64($0)!)})
        }

        if let albumIds = grouping[ShortcutType.ALBUM.rawValue] {
            let albumDetailService = AlbumDetailService()

            shortcutDictionary[ShortcutType.ALBUM.rawValue] = albumDetailService.findByIds(albumIds: albumIds.map {AlbumId(id: UInt64($0)!)})
        }

        if let playlistIds = grouping[ShortcutType.PLAYLIST.rawValue] {
            let playlistDetailService = PlaylistDetailService()

            shortcutDictionary[ShortcutType.PLAYLIST.rawValue] = playlistDetailService.findByIds(playlistIds: playlistIds.map {PlaylistId(id: $0)})
        }

        let shortcutModels = shortcutRealmModels
            .filter {(shortcutRealmModel) in shortcutDictionary[shortcutRealmModel.type]!.contains(where: {$0.shortcutId == shortcutRealmModel.itemId})}
            .map { shortcutRealmModel -> ShortcutModel in
                let itemModel = shortcutDictionary[shortcutRealmModel.type]!.first { $0.shortcutId == shortcutRealmModel.itemId }!

                return ShortcutModel(shortcutId: ShortcutId(id: shortcutRealmModel.id), itemId: ItemId(id: shortcutRealmModel.itemId), type: shortcutRealmModel.type, primaryText: itemModel.primaryText, artwork: itemModel.artwork)
            }

        if (!validation(shortcutIds: shortcutRealmModels.map {$0.id}, shortcutModels: shortcutModels)) {
            return findAll()
        }

        return shortcutModels
    }

    private func validation(shortcutIds: [String], shortcutModels: [ShortcutModel]) -> Bool {
        if shortcutIds.count == shortcutModels.count {
            return true
        }

        update(shortcutModels: shortcutModels)

        return false
    }

    private func update(shortcutModels: [ShortcutModel]) {
        let register = ShortcutRegister()

        register.update(shortcutIds: shortcutModels.map {$0.shortcutId})
    }
}

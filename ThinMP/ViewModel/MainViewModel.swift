//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MainViewModel: ViewModelProtocol {
    private let COUNT = 20

    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    func fetch() {
        let repository = AlbumRepository()
        let albums: [AlbumModel] = repository.findRecently(count: COUNT)

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

        var shortcutDictionary: [Int: [MediaProtocol]] = [ShortcutType.ARTIST.rawValue: [], ShortcutType.ALBUM.rawValue: [], ShortcutType.PLAYLIST.rawValue:[]]

        if let artistIds = grouping[ShortcutType.ARTIST.rawValue] {
            let artistRepository = ArtistRepository()
            let persistentIds = artistIds.map { UInt64($0)! as MPMediaEntityPersistentID}

            shortcutDictionary[ShortcutType.ARTIST.rawValue] = artistRepository.findByIds(persistentIds: persistentIds)
        }

        if let albumIds = grouping[ShortcutType.ALBUM.rawValue] {
            let albumRepository = AlbumRepository()
            let persistentIds = albumIds.map { UInt64($0)! as MPMediaEntityPersistentID}

            shortcutDictionary[ShortcutType.ALBUM.rawValue] = albumRepository.findByIds(persistentIds: persistentIds)
        }

        if let playlistIds = grouping[ShortcutType.PLAYLIST.rawValue] {
            let playlistRepository = PlaylistRepository()

            shortcutDictionary[ShortcutType.PLAYLIST.rawValue] = Array(playlistRepository.findByIds(playlistIds: playlistIds))
        }

        let shortcutModels2 = shortcutModels.map { shortcut -> ShortcutModel in
            let shortcut = shortcut
            let dictionary = shortcutDictionary[shortcut.type]
            let model = dictionary!.first { $0.shortcutId == shortcut.itemId }!

            shortcut.primaryText = model.primaryText
//            shortcut.artwork = model.artwork

            return shortcut
        }



        DispatchQueue.main.async {
            self.shortcuts = shortcutModels2
            self.albums = albums
        }
    }
}

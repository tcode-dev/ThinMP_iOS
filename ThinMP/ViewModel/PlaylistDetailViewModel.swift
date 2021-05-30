//
//  PlaylistDetailViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/11.
//

import RealmSwift
import MediaPlayer

class PlaylistDetailViewModel: ViewModelProtocol {
    @Published var name: String?
    @Published var artwork: MPMediaItemArtwork?
    @Published var list: [SongModel] = []

    let playlistId: String

    init(playlistId: String) {
        self.playlistId = playlistId
    }

    func fetch() {
        let playlistRepository = PlaylistRepository()
        let playlist = playlistRepository.findById(playlistId: playlistId)
        let playlistSongs = playlist.songs.sorted(byKeyPath: "order")
        let persistentIds = Array(playlistSongs.map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID})
        let repository = SongRepository()
        let songs = repository.findByIds(persistentIds: persistentIds)
        let sorted = persistentIds.map{ (persistentId) in songs.first { $0.persistentId == persistentId }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.artwork != nil)
        })?.artwork
        
        DispatchQueue.main.async {
            self.name = playlist.name
            self.artwork = artwork
            self.list = arrayed
        }
    }
}

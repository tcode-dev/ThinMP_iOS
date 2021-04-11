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
    @Published var songs: [MPMediaItemCollection] = []

    let playlistId: String

    init(playlistId: String) {
        self.playlistId = playlistId
        self.load()
    }

    func fetch() {
        let realm = try! Realm()
        let playlist = realm.objects(PlaylistRealm.self).filter("id = '\(playlistId)'").first!
        let songs = playlist.songs
        let persistentIds = songs.map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter{persistentIds.contains($0.representativeItem?.persistentID ?? 0)}
        let sorted = persistentIds
            .map{ (persistentId) in filtered.first { $0.representativeItem?.persistentID == persistentId }!}
        let arrayed = Array(sorted)
        let artwork = arrayed.first(where: { (song) -> Bool in
            (song.representativeItem?.artwork != nil)
        })?.representativeItem?.artwork
        
        DispatchQueue.main.async {
            self.name = playlist.name
            self.artwork = artwork
            self.songs = arrayed
        }
    }
}


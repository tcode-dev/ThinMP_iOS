//
//  FavoriteSongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import RealmSwift
import MediaPlayer

class FavoriteSongsViewModel: ViewModelProtocol {
    @Published var list: [SongModel] = []

    func fetch() {
        let realm = try! Realm()
        let persistentIds = realm.objects(FavoriteSongModel.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter{persistentIds.contains($0.representativeItem?.persistentID ?? 0)}
        let sorted = persistentIds
            .map{ (persistentId) in filtered.first { $0.representativeItem?.persistentID == persistentId }!}
            .map{SongModel(media: $0)}
        let arrayed = Array(sorted)

        DispatchQueue.main.async {
            self.list = arrayed
        }
    }
}

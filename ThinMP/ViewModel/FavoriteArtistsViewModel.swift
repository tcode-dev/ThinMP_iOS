//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//
import RealmSwift
import MediaPlayer

class FavoriteArtistsViewModel: ViewModelProtocol {
    @Published var list: [Artist] = []

    func fetch() {
        let realm = try! Realm()
        let persistentIds = realm.objects(FavoriteArtistRealm.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        let filtered = query.collections!.filter{persistentIds.contains($0.representativeItem?.artistPersistentID ?? 0)}
        let sorted = persistentIds
            .map{ (persistentId) in filtered.first { $0.representativeItem?.artistPersistentID == persistentId }}
            .map{ Artist(persistentId: $0?.representativeItem?.artistPersistentID, name:$0?.representativeItem?.artist)}

        DispatchQueue.main.async {
            self.list = Array(sorted)
        }
    }
}

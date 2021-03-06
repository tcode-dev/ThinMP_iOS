//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//
import RealmSwift
import MediaPlayer

class FavoriteArtistsViewModel: ObservableObject {
    @Published var list: [Artist] = []

    func load() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            fetch()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.fetch()
                }
            }
        }
    }

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

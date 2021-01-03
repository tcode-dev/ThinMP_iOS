//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//
import RealmSwift
import MediaPlayer

class FavoriteArtistsViewModel: ObservableObject {
    var persistentIds: [MPMediaEntityPersistentID]
    @Published var list: [Artist] = []

    init() {
        let realm = try! Realm()
        self.persistentIds = realm.objects(FavoriteArtistRealm.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.id) as MPMediaEntityPersistentID}

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
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()

        query.addFilterPredicate(property)

        list = query.collections!
            .filter{persistentIds.contains($0.representativeItem?.artistPersistentID ?? 0)}
            .map{return Artist(persistentId: $0.representativeItem?.artistPersistentID, name: $0.representativeItem?.artist)}
    }
}

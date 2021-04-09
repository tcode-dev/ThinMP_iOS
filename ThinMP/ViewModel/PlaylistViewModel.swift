//
//  PlaylistViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import RealmSwift
import MediaPlayer

class PlaylistViewModel: ObservableObject {
    @Published var list: [PlaylistRealm] = []

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
        let playlists = Array(realm.objects(PlaylistRealm.self).sorted(byKeyPath: "order"))
        DispatchQueue.main.async {
            self.list = playlists
        }
    }
}


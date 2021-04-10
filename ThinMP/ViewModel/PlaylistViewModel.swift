//
//  PlaylistViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import RealmSwift
import MediaPlayer

class PlaylistViewModel: ViewModelProtocol {
    @Published var list: [PlaylistRealm] = []

    func fetch() {
        let realm = try! Realm()
        let playlists = Array(realm.objects(PlaylistRealm.self).sorted(byKeyPath: "order"))

        DispatchQueue.main.async {
            self.list = playlists
        }
    }
}


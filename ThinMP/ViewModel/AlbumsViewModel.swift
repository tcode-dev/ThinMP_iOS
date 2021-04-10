//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

class AlbumsViewModel: ViewModelProtocol {
    @Published var list: [Album] = []

    func fetch() {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)

        let albums: [Album] = query.collections!.map{
            let item = $0.representativeItem

            return Album(persistentID: item?.albumPersistentID, title: item?.albumTitle, artist: item?.artist, artwork: item?.artwork)
        }

        DispatchQueue.main.async {
            self.list = albums
        }
    }
}

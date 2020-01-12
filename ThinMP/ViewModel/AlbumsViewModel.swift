//
//  AlbumsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import MediaPlayer

class AlbumsViewModel: ObservableObject {
    @Published var list: [Album] = []
    
    init () {
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
        let query = MPMediaQuery.albums()

        query.addFilterPredicate(property)
        
        list = query.collections!.enumerated().map{
            let offset = $0.offset
            let item = $0.element.representativeItem

            return Album(id: offset, persistentID: item?.albumPersistentID, title: item?.albumTitle, artist: item?.artist, artwork: item?.artwork)
        }
    }
}

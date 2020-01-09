//
//  Artists.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

class ArtistsViewModel: ObservableObject {
    @Published var list: [Artist] = []
    
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
        let query = MPMediaQuery.artists()
        
        query.addFilterPredicate(property)
        
        list = query.collections!.enumerated().map{
            return Artist(id: $0.offset, persistentId: $0.element.representativeItem?.artistPersistentID, name: $0.element.representativeItem?.artist ?? "unknown")
        }
    }
}

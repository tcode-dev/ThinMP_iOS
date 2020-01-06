//
//  Artists.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

class Artists: ObservableObject {
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
        
        list = query.collections!.map{
            Artist(name: $0.representativeItem?.artist ?? "unknown")
        }
    }
}

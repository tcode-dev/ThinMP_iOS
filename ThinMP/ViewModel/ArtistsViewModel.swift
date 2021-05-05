//
//  Artists.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import MediaPlayer

class ArtistsViewModel: ViewModelProtocol {
    @Published var list: [ArtistModel] = []

    func fetch() {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()
        
        query.addFilterPredicate(property)
        
        let artists = Array(query.collections!.map{
            return ArtistModel(persistentId: $0.representativeItem?.artistPersistentID, primaryText: $0.representativeItem?.artist)
        })
        DispatchQueue.main.async {
            self.list = artists
        }
    }
}

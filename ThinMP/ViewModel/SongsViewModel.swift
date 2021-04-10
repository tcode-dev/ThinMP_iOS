//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class SongsViewModel: ViewModelProtocol {
    @Published var list: [MPMediaItemCollection] = []

    func fetch() {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        let songs = query.collections ?? []

        DispatchQueue.main.async {
            self.list = songs
        }
    }
}

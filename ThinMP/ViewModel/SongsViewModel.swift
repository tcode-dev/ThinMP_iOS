//
//  SongsViewModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

class SongsViewModel: ViewModelProtocol {
    @Published var list: [SongModel] = []

    func fetch() {
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.songs()

        query.addFilterPredicate(property)

        let songs = query.collections!.map{SongModel(media: $0)}

        DispatchQueue.main.async {
            self.list = songs
        }
    }
}

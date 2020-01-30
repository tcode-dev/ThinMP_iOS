//
//  PlayingList.swift
//  ThinMP
//
//  Created by tk on 2020/01/30.
//

import MediaPlayer

class PlayingList {
    private var list:[MPMediaItemCollection] = []
    private var currentIndex: Int = 0;

    init(list:[MPMediaItemCollection], currentIndex: Int) {
        self.list = list
        self.currentIndex = currentIndex
    }
    
    func getSong() -> MPMediaItemCollection {
        return list[currentIndex]
    }
}

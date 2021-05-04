//
//  PlayingList.swift
//  ThinMP
//
//  Created by tk on 2020/01/30.
//

import MediaPlayer

class PlayingList {
    private var list:[SongModel] = []
    private var currentIndex: Int = 0;
    
    init(list:[SongModel], currentIndex: Int) {
        self.list = list
        self.currentIndex = currentIndex
    }
    
    func getSong() -> SongModel {
        return list[currentIndex]
    }
    
    func hasPrev() -> Bool {
        return self.currentIndex > 0
    }

    func hasNext() -> Bool {
        return self.currentIndex + 1 < list.count
    }
    
    func prev() {
        if (self.hasPrev()) {
            self.currentIndex -= 1
        } else {
            self.currentIndex = list.count - 1
        }
    }

    func next() {
        if (self.hasNext()) {
            self.currentIndex += 1
        } else {
            self.currentIndex = 0
        }
    }
}

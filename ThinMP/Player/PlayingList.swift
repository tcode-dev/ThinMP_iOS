//
//  PlayingList.swift
//  ThinMP
//
//  Created by tk on 2020/01/30.
//

import MediaPlayer

class PlayingList {
    private var list:[SongModel] = []
    private var originalList:[SongModel] = []
    private var currentIndex: Int

    init(list:[SongModel], currentIndex: Int) {
        self.originalList = list
        self.list = list
        self.currentIndex = currentIndex
    }

    func shuffle(shuffleMode: Bool) {
        let currentSong = getSong()

        if (shuffleMode) {
            var list = originalList
            list.remove(at: currentIndex)

            var shuffled = list.shuffled()
            shuffled.insert(currentSong, at: 0)
            self.list = shuffled
            currentIndex = 0
        } else {
            list = originalList
            if let index = list.firstIndex(where: {$0.id == currentSong.id}) {
                currentIndex = index
            }
        }
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

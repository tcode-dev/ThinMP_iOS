//
//  MainMenuConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/11.
//

import Foundation

struct MenuItem: Identifiable {
    var id: Int
    var name: String
}

class MainMenuConfig {
    private let KEY_SORT = "sort"

    init() {
        UserDefaults.standard.register(defaults: [KEY_SORT : [
            LabelConstant.artists,
            LabelConstant.albums,
            LabelConstant.songs, LabelConstant.favoriteArtists,
            LabelConstant.favoriteSongs,
            LabelConstant.playlists
        ]])
        UserDefaults.standard.register(defaults: [
            LabelConstant.artists: true,
            LabelConstant.albums: true,
            LabelConstant.songs: true,
            LabelConstant.favoriteArtists: true,
            LabelConstant.favoriteSongs: true,
            LabelConstant.playlists: true,
            LabelConstant.shortcuts: true,
            LabelConstant.recentlyAdded: true
        ])
    }

    func setSort(value: [String]) {
        UserDefaults.standard.set(value, forKey: KEY_SORT)
    }

    func setVisibility(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getList() -> [MenuItem] {
        return getSort()
            .filter {getVisibility(key: $0)}
            .enumerated()
            .map{MenuItem(id: $0.offset, name: $0.element)}
    }

    private func getSort() -> [String] {
        return UserDefaults.standard.array(forKey: KEY_SORT) as! [String]
    }

    private func getVisibility(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}

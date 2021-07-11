//
//  MainMenuConfig.swift
//  ThinMP
//
//  Created by tk on 2021/06/11.
//

import Foundation
import SwiftUI

class MainMenuConfig {
    private let KEY_SORT = "sort"

    init() {
        UserDefaults.standard.register(defaults: [KEY_SORT: [
            LabelConstant.artists,
            LabelConstant.albums,
            LabelConstant.songs,
            LabelConstant.favoriteArtists,
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
            LabelConstant.shortcut: true,
            LabelConstant.recentlyAdded: true
        ])
    }

    func setSort(value: [String]) {
        UserDefaults.standard.set(value, forKey: KEY_SORT)
    }

    func setVisibility(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getList() -> [MenuModel] {
        return getSort()
            .enumerated()
            .map {MenuModel(primaryText: $0.element, visibility: getVisibility(key: $0.element))}
    }

    private func getSort() -> [String] {
        return UserDefaults.standard.array(forKey: KEY_SORT) as! [String]
    }

    private func getVisibility(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}

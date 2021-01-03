//
//  FavoriteArtistRealm.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//
import RealmSwift
import Foundation

class FavoriteArtistRealm: Object {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var order: Int = 1
}

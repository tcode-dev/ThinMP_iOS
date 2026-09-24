//
//  RealmStore.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import RealmSwift

/// Realm の接続設定
/// アプリでは default を使い、テストではインメモリ Realm に差し替える
struct RealmStore {
    static var `default`: RealmStore {
        return RealmStore(configuration: Realm.Configuration.defaultConfiguration)
    }

    let configuration: Realm.Configuration

    /// インメモリ Realm は同じ identifier を持つ Realm インスタンスがすべて解放されると消える
    static func inMemory(identifier: String = UUID().uuidString) -> RealmStore {
        return RealmStore(configuration: Realm.Configuration(inMemoryIdentifier: identifier))
    }

    /// 指定したファイルの Realm。移行処理のテストでフィクスチャを開くために使う
    static func file(url: URL) -> RealmStore {
        return RealmStore(configuration: Realm.Configuration(fileURL: url))
    }

    func realm() -> Realm {
        return try! Realm(configuration: configuration)
    }
}

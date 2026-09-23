//
//  SwiftDataStoreTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Foundation
import Testing
@testable import ThinMP

@MainActor
struct SwiftDataStoreTests {
    /// 登録 / 解除のボタンは、この通知で別の場所での書き込みを表示に反映する
    @Test
    func saveNotifiesDidSaveWithStore() {
        let store = SwiftDataStore.inMemory()
        let otherStore = SwiftDataStore.inMemory()
        var count = 0
        let observer = NotificationCenter.default.addObserver(forName: SwiftDataStore.didSave, object: store, queue: nil) { _ in
            count += 1
        }

        defer {
            NotificationCenter.default.removeObserver(observer)
        }

        FavoriteSongRepository(store: store).add(songId: SongId(id: 1))
        FavoriteSongRepository(store: otherStore).add(songId: SongId(id: 1))

        #expect(count == 1)
    }
}

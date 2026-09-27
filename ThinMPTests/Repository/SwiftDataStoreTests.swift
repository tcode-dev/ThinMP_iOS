//
//  SwiftDataStoreTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Foundation
import os
import Testing
@testable import ThinMP

@MainActor
struct SwiftDataStoreTests {
    /// 登録 / 解除のボタンは、この通知で別の場所での書き込みを表示に反映する
    @Test
    func saveNotifiesDidSaveWithStore() {
        let store = SwiftDataStore.inMemory()
        let otherStore = SwiftDataStore.inMemory()
        // observer のブロックは Sendable なので、ローカル変数を直接書き換えずにロック越しに数える
        let count = OSAllocatedUnfairLock(initialState: 0)
        let observer = NotificationCenter.default.addObserver(forName: .swiftDataStoreDidSave, object: store, queue: nil) { _ in
            count.withLock { $0 += 1 }
        }

        defer {
            NotificationCenter.default.removeObserver(observer)
        }

        FavoriteSongRepository(store: store).add(songId: SongId(id: 1))
        FavoriteSongRepository(store: otherStore).add(songId: SongId(id: 1))

        #expect(count.withLock { $0 } == 1)
    }
}

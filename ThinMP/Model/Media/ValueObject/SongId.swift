//
//  SongId.swift
//  ThinMP
//
//  Created by tk on 2021/06/21.
//

import MediaPlayer

struct SongId {
    var id: MPMediaEntityPersistentID

    func equals(_ songId: SongId) -> Bool {
        return songId.id == id
    }
}

extension Array where Element == SongId {
    /// 同じ id は最初の 1 回だけ残し、並び順は保つ
    func uniqued() -> [SongId] {
        var seen = Set<MPMediaEntityPersistentID>()

        return filter { seen.insert($0.id).inserted }
    }
}

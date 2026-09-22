//
//  SongId.swift
//  ThinMP
//
//  Created by tk on 2021/06/21.
//

import MediaPlayer

struct SongId: Hashable {
    var id: MPMediaEntityPersistentID
}

extension Array where Element == SongId {
    /// 同じ id は最初の 1 回だけ残し、並び順は保つ
    func uniqued() -> [SongId] {
        var seen = Set<SongId>()

        return filter { seen.insert($0).inserted }
    }
}

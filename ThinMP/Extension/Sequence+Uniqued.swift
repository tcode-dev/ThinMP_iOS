//
//  Sequence+Uniqued.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

extension Sequence where Element: Hashable {
    /// 同じ要素は最初の 1 回だけ残し、並び順は保つ
    func uniqued() -> [Element] {
        var seen = Set<Element>()

        return filter { seen.insert($0).inserted }
    }
}

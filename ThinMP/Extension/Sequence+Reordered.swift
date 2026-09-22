//
//  Sequence+Reordered.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

extension Sequence {
    /// ids の順に並べ直す。ids に無い要素は落とし、ids にあって self に無いものは飛ばす。同じ id が複数あれば最初のもの
    /// MPMediaQuery には IN 述語が無いので、ライブラリを 1 回取得してからこれで絞る
    func reordered<ID: Hashable>(by ids: [ID], id: (Element) -> ID) -> [Element] {
        let lookup = keyed(by: id)

        return ids.compactMap { lookup[$0] }
    }
}

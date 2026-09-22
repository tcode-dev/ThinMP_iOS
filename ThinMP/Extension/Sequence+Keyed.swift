//
//  Sequence+Keyed.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

extension Sequence {
    /// id をキーにした辞書。同じ id が複数あれば最初のもの
    /// ライブラリから取った一覧を id で引き直すのに使う
    func keyed<ID: Hashable>(by id: (Element) -> ID) -> [ID: Element] {
        return Dictionary(map { (id($0), $0) }, uniquingKeysWith: { first, _ in first })
    }
}

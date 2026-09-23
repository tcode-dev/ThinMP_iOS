//
//  MPMediaQuery+Local.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import MediaPlayer

extension MPMediaQuery {
    /// クラウドにしか無い項目を除いたクエリにして返す
    /// 一覧と詳細で出る項目を揃えるため、ライブラリの取得はどれもこれを通したクエリから始める
    func excludingCloudItems() -> MPMediaQuery {
        addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))

        return self
    }
}

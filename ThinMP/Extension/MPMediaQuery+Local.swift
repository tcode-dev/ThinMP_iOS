//
//  MPMediaQuery+Local.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import MediaPlayer

extension MPMediaQuery {
    /// 端末にある項目だけに絞ったクエリにして返す(クラウドにしか無い項目を除く)
    /// 一覧と詳細で出る項目を揃えるため、ライブラリの取得はどれもこれを通したクエリから始める
    func localItems() -> MPMediaQuery {
        addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))

        return self
    }
}

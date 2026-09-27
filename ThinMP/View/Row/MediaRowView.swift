//
//  MediaRowView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct MediaRowView: View {
    let media: MediaProtocol
    /// 2 行目(アーティスト名など)を出すか。プレイリストは 2 行目を持たないので false にする
    /// 出すときは secondaryText が nil か空なら「不明」にする(再生画面やアルバムのセルと同じ)
    var showsSecondaryText = true

    var body: some View {
        HStack {
            SquareImageView(artwork: media.artwork, size: StyleConstant.thumbnail)
            VStack(alignment: .leading) {
                PrimaryTextView(media.primaryText)
                if showsSecondaryText {
                    SecondaryTextView(media.secondaryText)
                }
            }
            Spacer()
        }
        .rowStyle()
    }
}

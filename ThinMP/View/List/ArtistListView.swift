//
//  ArtistListView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// アーティストの一覧。行をタップで詳細へ、長押しでお気に入りとショートカットのメニューを出す
struct ArtistListView: View {
    let artists: [ArtistModel]
    /// お気に入りの登録・解除後に呼ばれる(一覧の再読み込みなど)
    var onFavoriteChange: () -> Void = {}

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(artists) { artist in
                NavigationLink(destination: ArtistDetailPageView(artistId: artist.artistId)) {
                    PlainRowView(media: artist)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    FavoriteArtistButtonView(artistId: artist.artistId, callback: onFavoriteChange)
                    ShortcutButtonView(artistId: artist.artistId)
                }
                Divider()
            }
            .padding(.leading, StyleConstant.Padding.medium)
        }
    }
}

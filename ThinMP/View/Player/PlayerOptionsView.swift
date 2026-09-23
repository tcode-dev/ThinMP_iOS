//
//  PlayerOptionsView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// リピート / シャッフル / お気に入り(アーティスト、曲)/ プレイリストに追加
struct PlayerOptionsView: View {
    private let imageSize: CGFloat = 50
    /// お気に入り曲のアイコンだけ余白の取り方が違うので一回り小さくする
    private let favoriteSongImageSize: CGFloat = 40
    private let horizontalPadding: CGFloat = StyleConstant.isPad ? 50 : 30

    @EnvironmentObject private var musicPlayer: MusicPlayer

    /// プレイリストに追加を押したときに呼ばれる
    let onAddPlaylist: () -> Void

    var body: some View {
        HStack {
            Button(action: musicPlayer.changeRepeat) {
                switch musicPlayer.repeatMode {
                case .all:
                    ButtonImageView(image: .repeatButton, size: imageSize)
                case .one:
                    ButtonImageView(image: .repeatOneButton, size: imageSize)
                default:
                    ButtonImageView(image: .repeatButton, size: imageSize, dimmed: true)
                }
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.shuffle) {
                ButtonImageView(image: .shuffleButton, size: imageSize, dimmed: !musicPlayer.isShuffle)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.toggleFavoriteArtist) {
                ButtonImageView(image: .favoriteArtistButton, size: imageSize, dimmed: !musicPlayer.isFavoriteArtist)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.toggleFavoriteSong) {
                ButtonImageView(image: .favoriteSongButton, size: favoriteSongImageSize, dimmed: !musicPlayer.isFavoriteSong)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: onAddPlaylist) {
                ButtonImageView(image: .playlistAddButton, size: imageSize)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
        }
        .padding(.horizontal, horizontalPadding)
    }
}

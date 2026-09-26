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

    @Environment(MusicPlayer.self) private var musicPlayer

    /// プレイリストに追加を押したときに呼ばれる
    let onAddPlaylist: () -> Void

    var body: some View {
        HStack {
            Button(action: musicPlayer.changeRepeat) {
                switch musicPlayer.repeatMode {
                case .all:
                    ButtonImageView(image: .repeatButton, label: LabelConstant.repeatAll, size: imageSize)
                case .one:
                    ButtonImageView(image: .repeatOneButton, label: LabelConstant.repeatOne, size: imageSize)
                default:
                    ButtonImageView(image: .repeatButton, label: LabelConstant.repeatAll, size: imageSize, dimmed: true)
                }
            }
            .accessibilityAddTraits(musicPlayer.repeatMode != .none ? .isSelected : [])
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.shuffle) {
                ButtonImageView(image: .shuffleButton, label: LabelConstant.shuffle, size: imageSize, dimmed: !musicPlayer.isShuffle)
            }
            .accessibilityAddTraits(musicPlayer.isShuffle ? .isSelected : [])
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.toggleFavoriteArtist) {
                ButtonImageView(image: .favoriteArtistButton, label: LabelConstant.favoriteArtist, size: imageSize, dimmed: !musicPlayer.isFavoriteArtist)
            }
            .accessibilityAddTraits(musicPlayer.isFavoriteArtist ? .isSelected : [])
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.toggleFavoriteSong) {
                ButtonImageView(image: .favoriteSongButton, label: LabelConstant.favoriteSong, size: favoriteSongImageSize, dimmed: !musicPlayer.isFavoriteSong)
            }
            .accessibilityAddTraits(musicPlayer.isFavoriteSong ? .isSelected : [])
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: onAddPlaylist) {
                ButtonImageView(image: .playlistAddButton, label: LabelConstant.addPlaylist, size: imageSize)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
        }
        .padding(.horizontal, horizontalPadding)
    }
}

//
//  PlayerOptionsView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// リピート / シャッフル / お気に入り(アーティスト、曲)/ プレイリストに追加
struct PlayerOptionsView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    /// プレイリストに追加を押したときに呼ばれる
    let onAddPlaylist: () -> Void

    var body: some View {
        HStack {
            Button(action: musicPlayer.changeRepeat) {
                switch musicPlayer.repeatMode {
                case .all:
                    ButtonImageView(name: "RepeatButton", size: 50)
                case .one:
                    ButtonImageView(name: "RepeatOneButton", size: 50)
                default:
                    ButtonImageView(name: "RepeatButton", size: 50, dimmed: true)
                }
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.shuffle) {
                ButtonImageView(name: "ShuffleButton", size: 50, dimmed: !musicPlayer.isShuffle)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.favoriteArtist) {
                ButtonImageView(name: "FavoriteArtistButton", size: 50, dimmed: !musicPlayer.isFavoriteArtist)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: musicPlayer.favoriteSong) {
                ButtonImageView(name: "FavoriteSongButton", size: 40, dimmed: !musicPlayer.isFavoriteSong)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
            Spacer()
            Button(action: onAddPlaylist) {
                ButtonImageView(name: "PlaylistAddButton", size: 50)
            }
            .frame(width: StyleConstant.button, height: StyleConstant.button)
        }
        .padding(.horizontal, StyleConstant.isPad ? 50 : 30)
    }
}

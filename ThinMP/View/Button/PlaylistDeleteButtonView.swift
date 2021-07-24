//
//  PlaylistDeleteButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/07/18.
//

import SwiftUI

struct PlaylistDeleteButtonView: View {
    private let playlistId: PlaylistId
    private let callback: () -> Void

    init(playlistId: PlaylistId, callback: @escaping () -> Void = {}) {
        self.playlistId = playlistId
        self.callback = callback
    }

    var body: some View {
        Button(action: {
            let register = PlaylistRegister()

            register.delete(playlistId: playlistId)

            callback()
        }) {
            Text(LocalizedStringKey(LabelConstant.removePlaylist))
        }
    }
}

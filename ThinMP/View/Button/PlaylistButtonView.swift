//
//  PlaylistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI

struct PlaylistButtonView: View {
    @Binding var isRegister: Bool

    var body: some View {
        Button(action: {
            self.isRegister.toggle()
        }) {
            Text("AddPlaylist")
        }
    }
}

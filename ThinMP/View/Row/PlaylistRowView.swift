//
//  PlaylistRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistRowView: View {
    let title: String

    var body: some View {
        HStack {
            PrimaryTextView(title)
            Spacer()
        }
    }
}

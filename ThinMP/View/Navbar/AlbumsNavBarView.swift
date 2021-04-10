//
//  AlbumsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct AlbumsNavBarView: View {
    private let TITLE: String = "Albums"

    let top: CGFloat
    @Binding var rect: CGRect

    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            Spacer()
                .frame(width: 50)
        }
    }
}

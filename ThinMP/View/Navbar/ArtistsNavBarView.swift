//
//  ArtistsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct ArtistsNavBarView: View {
    private let TITLE: String = "Artists"

    let top: CGFloat
    @Binding var rect: CGRect

    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            EmptyView()
        }
    }
}

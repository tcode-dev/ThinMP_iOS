//
//  SongsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import SwiftUI

struct SongsNavBarView: View {
    private let TITLE: String = "Songs"

    let top: CGFloat
    @Binding var rect: CGRect

    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            Spacer()
                .frame(width: 50)
        }
    }
}

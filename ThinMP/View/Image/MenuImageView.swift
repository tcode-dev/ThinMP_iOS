//
//  MenuImageView.swift
//  ThinMP
//
//  Created by tk on 2020/06/05.
//

import SwiftUI

struct MenuImageView: View {
    private let size: CGFloat = 32

    var body: some View {
        Image(.menuButton)
            .renderingMode(.original)
            .resizable()
            .frame(width: size, height: size)
    }
}

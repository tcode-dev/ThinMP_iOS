//
//  BackImageView.swift
//  ThinMP
//
//  Created by tk on 2020/06/05.
//

import SwiftUI

struct MenuImageView: View {
    var body: some View {
        Image("MenuButton")
            .renderingMode(.original)
            .resizable()
            .frame(width: 32, height: 32)
    }
}

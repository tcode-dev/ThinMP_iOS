//
//  PlainRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/10.
//

import SwiftUI

struct PlainRowView: View {
    let media: MediaProtocol

    var body: some View {
        HStack {
            PrimaryTextView(media.primaryText)
            Spacer()
        }
        .frame(height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.Padding.tiny)
        .padding(.trailing, StyleConstant.Padding.tiny)
    }
}

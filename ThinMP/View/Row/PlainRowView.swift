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
            VStack(alignment: .leading) {
                PrimaryTextView(media.primaryText)
            }
            .frame(height: 34)
            Spacer()
        }
        .padding(StyleConstant.Padding.tiny)
    }
}

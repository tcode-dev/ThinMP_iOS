//
//  MediaRowView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct MediaRowView: View {
    let media: MediaProtocol

    var body: some View {
        HStack {
            SquareImageView(artwork: media.artwork, size: StyleConstant.thumbnail)
            VStack(alignment: .leading) {
                PrimaryTextView(media.primaryText)
                if let secondaryText = media.secondaryText {
                    SecondaryTextView(secondaryText)
                }
            }
            Spacer()
        }
        .modifier(RowModifier())
    }
}

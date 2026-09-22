//
//  MediaRowView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct MediaRowView: View {
    private let size: CGFloat = 40

    let media: MediaProtocol

    var body: some View {
        HStack {
            SquareImageView(artwork: media.artwork, size: size)
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

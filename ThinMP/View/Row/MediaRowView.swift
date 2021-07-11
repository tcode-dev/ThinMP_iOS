//
//  MediaRowView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer
import SwiftUI

struct MediaRowView: View {
    private let size: CGFloat = 40

    let media: MediaProtocol

    var body: some View {
        HStack {
            SquareImageView(artwork: media.artwork, size: size)
            VStack(alignment: .leading) {
                PrimaryTextView(media.primaryText)
                if media.secondaryText != nil {
                    SecondaryTextView(media.secondaryText)
                }
            }
            .frame(height: 34)
            Spacer()
        }
        .padding(StyleConstant.Padding.small)
    }
}

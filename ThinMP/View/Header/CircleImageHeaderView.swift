//
//  CircleImageHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import MediaPlayer
import SwiftUI

struct CircleImageHeaderView: View {
    @Binding var headerRect: CGRect

    let side: CGFloat
    let top: CGFloat
    let primaryText: String?
    let secondaryText: String?
    let artwork: MPMediaItemArtwork?

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: artwork?.image(at: CGSize(width: side, height: side)) ?? UIImage())
                .resizable()
                .scaledToFit()
                .blur(radius: 10.0)
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom).frame(height: 355).offset(y: 25)
            CircleImageView(artwork: artwork, size: side / 3)
                .offset(y: -(side / 3))
            GeometryReader { primaryTextGeometry in
                createPrimaryTextView(primaryTextGeometry: primaryTextGeometry)
            }
            .frame(height: StyleConstant.Height.row)
            .offset(y: -40)
            SecondaryTextView(secondaryText)
                .frame(width: abs(side - (StyleConstant.button * 2)), height: 25, alignment: .center)
                .offset(y: -30)
                .padding(.leading, StyleConstant.button)
                .padding(.trailing, StyleConstant.button)
        }
        .frame(height: side)
    }

    /// PrimaryTextのViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、親が子のgeometryを参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    private func createPrimaryTextView(primaryTextGeometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            headerRect = primaryTextGeometry.frame(in: .global)
        }

        return VStack {
            TitleView(primaryText).opacity(textOpacity())
        }
        .frame(width: abs(side - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.button)
        .padding(.trailing, StyleConstant.button)
    }

    private func textOpacity() -> Double {
        if headerRect.origin.y - top > 0 {
            return 1
        }

        return 0
    }
}
